extends PathFollow3D

@export var speed := 4.0
@export var stop_ratio := 0.35
@export var wait_time := 3.0

var waiting := false
var stopped := false

func _process(delta):
	if waiting:
		return

	progress += speed * delta

	if not stopped and progress_ratio >= stop_ratio:
		stopped = true
		waiting = true
		await get_tree().create_timer(wait_time).timeout
		waiting = false
