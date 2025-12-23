extends PathFollow3D

@export var speed := 4.0
#stop ratio here is where it still the car to stop at 35% of the path 
@export var stop_ratio := 0.35
@export var wait_time := 3.0

var waiting := false
var stopped := false

func _process(delta):
	if waiting:
		return
	
	#move the object forward along the path , its like a distance = speed * s 
	progress += speed * delta 

	if not stopped and progress_ratio >= stop_ratio:
		stopped = true
		waiting = true
		await get_tree().create_timer(wait_time).timeout
		waiting = false
