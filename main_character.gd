extends Node3D

@onready var camera_pivot = $CameraPivot
@onready var hand_slot = $HandSlot
@onready var anim_player = $AnimationPlayer  # Adjust path if nested under Armature

@export var mouse_sensitivity := 0.3
@export var move_speed := 5.0

var rotation_x := 0.0  # vertical look
var rotation_y := 0.0  # horizontal look
var held_item: Node3D = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # show cursor when menu loadsshow_main_menu()


#handle the movement of the mouse, camera and character 
#- Rotates the player horizontally (rotation_y) and the camera pivot vertically (rotation_x).- Vertical rotation is clamped between -80° and 80° to prevent flipping
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -80, 80)

		rotation_degrees.y = rotation_y
		camera_pivot.rotation_degrees.x = rotation_x

func _physics_process(delta):
	var input_dir = Vector3.ZERO
	#read movement input 
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")

	var direction = (transform.basis * input_dir).normalized()
	global_transform.origin += direction * move_speed * delta

	# Animation control
	if direction != Vector3.ZERO:
		if not anim_player.is_playing() or anim_player.current_animation != "ArmatureAction":
			anim_player.play("ArmatureAction")

func pick_up(item: Node3D):
	if held_item == null:
		held_item = item
		item.get_parent().remove_child(item)
		hand_slot.add_child(item)
		item.transform = Transform3D.IDENTITY
		if item is RigidBody3D:
			item.freeze = true   # Godot 4 way to disable physics

func drop_item():
	if held_item != null:
		var item = held_item
		held_item = null
		hand_slot.remove_child(item)
		get_parent().add_child(item)
		item.global_transform = hand_slot.global_transform
		if item is RigidBody3D:
			item.freeze = false  # re-enable physics
func try_pickup():
	# Simple raycast forward from the player
	var space_state = get_world_3d().direct_space_state
	var from = global_transform.origin
	var to = from + -transform.basis.z * 2.0   # 2 units in front of player
	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.exclude = [self]  # optional: ignore the player itself
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)

	if result and result.collider.is_in_group("pickup"):
		pick_up(result.collider)
func _input(event):
	if event.is_action_pressed("interact"):
		if held_item:
			drop_item()
		else:
			try_pickup()
