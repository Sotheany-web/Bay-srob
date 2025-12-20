extends Node3D
@onready var camera_pivot = $CameraPivot

@export var mouse_sensitivity := 0.3
@export var move_speed := 5.0

var rotation_x := 0.0  # vertical look
var rotation_y := 0.0  # horizontal look

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -80, 80)

		rotation_degrees.y = rotation_y
		camera_pivot.rotation_degrees.x = rotation_x

func _physics_process(delta):
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")

	var direction = (transform.basis * input_dir).normalized()
	global_transform.origin += direction * move_speed * delta
