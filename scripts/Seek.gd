class_name Seek extends SteeringBehavior

@export var target:Vector3
var world_target:Vector3
var slowing_distance: float = 0.5  # Distance at which the boid should start slowing down

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()

func calculate():
	if target:
		var distance_to_target = boid.global_transform.origin.distance_to(target)

		if distance_to_target < slowing_distance:
			# Use arrive_force to slow down as it approaches the target
			return boid.arrive_force(target, slowing_distance)
		else:
			# Use seek_force to move towards the target at full speed
			return boid.seek_force(target)
	return Vector3.ZERO

func set_target(new_target: Vector3):
	target = new_target
