class_name SwimToShore extends State

var boid
var duck_animation_player: AnimationPlayer
var random_shore_point: Vector3
var shore_radius := 4
var shore_spawn_points


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	
	# Get the shore spawn points
	shore_spawn_points = get_node("../../").get_children().filter(
		func(child):
		return child is Marker3D and child.name.begins_with("ShoreSpawnPoint")
	)
	
	# Get the animation player
	duck_animation_player = get_node("../Sketchfab_Scene/AnimationPlayer")

func _enter():
	# Play swim animation
	duck_animation_player.play("Arm_duck|swim")
	
	# Disable flocking and other behaviors unless it's seek
	for i in boid.behaviors.size():
		if not boid.behaviors[i] is Seek:
			boid.set_enabled(boid.behaviors[i], false)
	
	# Get a random shore point
	var random_index = randi() % shore_spawn_points.size()
	random_shore_point = Utility.get_random_position_inside_circle(shore_spawn_points[random_index].global_transform.origin, 4)
	print(random_shore_point)
	
	# Set seek behavior's target
	var seek_behavior = boid.get_node("Seek")
	seek_behavior.set_target(random_shore_point)
	seek_behavior.call_deferred("calculate")

func _think():
	# Check if duck is on land and if so switch to walk animation
	if not boid.is_touching_water and duck_animation_player.current_animation != "Arm_duck|walk":
		duck_animation_player.play("Arm_duck|walk")
	
	# Check if duck arrived then change state to a land state
	var distance_to_target = boid.global_transform.origin.distance_to(random_shore_point)

	if distance_to_target < 2 and boid.vel.length() < 0.05:
		print("Arrived")
		boid.get_node("StateMachine").change_state(Sleep.new())

func _exit():
	boid.set_enabled(boid.get_node("Seek"), false)
	
	boid.vel = Vector3.ZERO
	boid.force = Vector3.ZERO

func constrain_to_water_level():
	# Constrain the y-coordinate to the water level
	var position = boid.global_transform.origin
	position.y = -0.25
	boid.global_transform.origin = position


