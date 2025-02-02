class_name Flock extends Node

@export var duck:PackedScene
@export var duck_count: int = 30

@export var neighbor_distance = 20
@export var max_neighbors = 5

var boids = []

@export var partition = false

@export var LakeSpawnPoint:NodePath
@export var lake_spawn_chance: float = 0.8
@export var LakeRadiusSpawn: int = 25
@export var ShoreRadiusSpawn: int = 4
var shore_spawn_points = []


func _process(delta):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_ducks()


func spawn_ducks():
	# Get the shore spawn points using Marker3D
	shore_spawn_points = get_children().filter(
		func(child):
		return child is Marker3D and child.name.begins_with("ShoreSpawnPoint")
	)
	
	for i in range(duck_count):
		var spawn_point: Vector3
		var will_spawn_in_lake: bool
		# Determining whether ducks will spawn in water or beside the shore
		if randf() < lake_spawn_chance:
			var center = get_node(LakeSpawnPoint)
			spawn_point = Utility.get_random_position_inside_circle(center.global_transform.origin, LakeRadiusSpawn)
			
			will_spawn_in_lake = true
		else:
			var random_index = randi() % shore_spawn_points.size()
			var center = shore_spawn_points[random_index]
			
			spawn_point = Utility.get_random_position_inside_circle(center.global_transform.origin, ShoreRadiusSpawn)
		
			will_spawn_in_lake = false
		
		# Creating an instance of duck and setting its position in global space
		var duck_instance = duck.instantiate()
		duck_instance.did_spawn_in_lake = will_spawn_in_lake
		add_child(duck_instance)
		duck_instance.global_position = spawn_point
		duck_instance.global_rotation = Vector3(0, randf_range(0, PI * 2.0), 0)
		
		var boid
		if duck_instance is Boid:
			boid = duck_instance
		else:
			boid = duck_instance.find_child("Boid", true)

		boids.push_back(boid)
