class_name Alignment extends SteeringBehavior

var force = Vector3.ZERO
var desired = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	boid.count_neighbors = true


func calculate():
	desired = Vector3.ZERO
	
	for i in boid.neighbors.size():
		var other = boid.neighbors[i]
		var other_direction = other.global_transform.basis.z
		other_direction.y = 0
		desired += other_direction
	if boid.neighbors.size() > 0:
		desired = desired / boid.neighbors.size()
		desired.y = 0
		force = desired - boid.global_transform.basis.z
		force.y = 0
	return force

