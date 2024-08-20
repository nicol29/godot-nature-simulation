class_name Swim extends State

var boid
@export var water:NodePath
@export var target:Node3D
var timer


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	
	timer = Timer.new()
	add_child(timer)	
	timer.wait_time = 1
	timer.one_shot = false
	timer.start()
	timer.connect("timeout", Callable(self, "timeout"))	

	
	pass # Replace with function body.

func timeout():
	timer.wait_time = randf_range(0.2, 1)

func _enter():
	pass
		
func _think():
	pass
	

func constrain_to_water_level():
	# Constrain the y-coordinate to the water level
	var position = boid.global_transform.origin
	#position.y = water_level
	boid.global_transform.origin = position
