class_name Constrain extends SteeringBehavior

@export var radius:float = 20

var center

func _ready():
	boid = get_parent()
	center = get_parent().get_parent().get_node("LakeSpawnPoint")


func calculate():
	var to_center = center.global_transform.origin - boid.global_transform.origin if center else Vector3.ZERO
	var distance = to_center.length()

	# If the boid is outside the radius, guide it back
	if distance > radius:
		var power = distance - radius 
		var nudge = to_center.normalized() * power * 0.1 
		return nudge
	else:
		return Vector3.ZERO 
