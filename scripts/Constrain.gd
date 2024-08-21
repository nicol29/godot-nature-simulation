class_name Constrain extends SteeringBehavior

@export var radius:float = 20

@export var center_path:NodePath

var center

func _ready():
	boid = get_parent()
	center = get_parent().get_parent().get_node("LakeSpawnPoint")
	# boid.transform.rotated()
	pass # Replace with function body.

#func calculate():
##	Inline IF!! 
	#var to_center = center.global_transform.origin - boid.global_transform.origin if center else - boid.global_transform.origin 
##	
	#var power = max(to_center.length() - radius, 0)
	#return to_center.limit_length(power)

func calculate():
	var to_center = center.global_transform.origin - boid.global_transform.origin if center else Vector3.ZERO
	var distance = to_center.length()

	# If the boid is outside the radius, apply a small force to guide it back
	if distance > radius:
		var power = distance - radius 
		var nudge = to_center.normalized() * power * 0.1 
		return nudge
	else:
		return Vector3.ZERO  # Apply no constraint force if inside the radius
