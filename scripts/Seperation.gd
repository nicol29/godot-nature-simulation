class_name Separation extends SteeringBehavior 

var force = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	boid.count_neighbors = true


func calculate():
	force = Vector3.ZERO
	
	for i in boid.neighbors.size():
		var other = boid.neighbors[i]
		var away = boid.global_transform.origin - other.global_transform.origin
		away.y = 0
		force += away.normalized() / away.length()
	
	return force

