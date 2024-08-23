class_name Wander extends SteeringBehavior

@export var distance:float = 6
@export var radius:float  = 4
@export var jitter:float = 50

var target:Vector3
var world_target:Vector3
var wander_target:Vector3

func _ready():
	boid = get_parent()
	wander_target = Utility.random_point_in_unit_disk() * 2

func calculate():		
	var delta = get_process_delta_time()
	var disp = jitter * Utility.random_point_in_unit_disk() * delta
	wander_target += disp
	wander_target = wander_target.limit_length(radius)
	var local_target = (Vector3.BACK * distance) + wander_target

	world_target = boid.global_transform * (local_target)
	
	return boid.seek_force(world_target)

func set_target(new_target: Vector3):
	target = new_target
