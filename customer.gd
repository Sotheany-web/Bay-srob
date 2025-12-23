extends Node3D

@onready var area = $Area3D
@onready var anim_player = $AnimationPlayer   # adjust path if needed

func _ready():
	area.body_entered.connect(_on_body_entered)

func _process(delta):
	# Play walk animation while moving along path
	if anim_player and not anim_player.is_playing():
		anim_player.play("ArmatureAction")

func _on_body_entered(body):
	if body.name == "Player" and body.held_item != null:
		receive_item(body.held_item)
		body.held_item.queue_free()
		body.held_item = null
		stop_walking()   # stop animation when delivering

func receive_item(item: Node3D):
	print("Customer received: ", item.name)

func stop_walking():
	if anim_player and anim_player.is_playing():
		anim_player.stop()
