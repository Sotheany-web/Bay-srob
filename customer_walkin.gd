extends PathFollow3D

@export var walk_speed: float = 2.0
@export var stop_point_index: int = 5

var ai_state := "walking"
var wait_timer := 3.0

func _process(delta):
	match ai_state:
		"walking":
			progress += walk_speed * delta
			check_stop_point()

		"waiting":
			wait_timer -= delta
			if wait_timer <= 0:
				ai_state = "done"

		"done":
			pass

func check_stop_point():
	var path := get_parent() as Path3D
	var curve: Curve3D = path.curve
	var current_pos := global_position

	var closest_index := 0
	var closest_dist := INF

	for i in range(curve.point_count):
		var dist = current_pos.distance_to(curve.get_point_position(i))
		if dist < closest_dist:
			closest_dist = dist
			closest_index = i

	if closest_index == stop_point_index:
		ai_state = "waiting"
		wait_timer = 3.0
