class_name Seek extends SteeringBehavior

@export var target:Node3D
var world_target:Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()

func calculate():
	if target:		
		world_target = target.global_transform.origin
	return boid.seek_force(world_target)

func set_target(new_target: Node3D):
	target = new_target
