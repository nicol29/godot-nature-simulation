class_name ReturnToPond extends State

var boid
var duck_animation_player: AnimationPlayer
var lake_point: Marker3D
var shore_radius := 4
var shore_spawn_points


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	
	# Get the shore spawn points
	lake_point = get_node("../../LakeSpawnPoint")
	
	# Get the animation player
	duck_animation_player = get_node("../Sketchfab_Scene/AnimationPlayer")

func _enter():
	# Play swim animation
	duck_animation_player.play("Arm_duck|walk")
	
	# Disable flocking and other behaviors unless it's seek
	for behavior in boid.behaviors:
		if not behavior is Seek:
			boid.set_enabled(behavior, false)
		else:
			boid.set_enabled(behavior, true)
	
	# Set seek behavior's target
	var seek_behavior = boid.get_node("Seek")
	seek_behavior.set_target(lake_point.global_transform.origin)

func _think():
	# Check if duck is in water and if so switch to swim animation
	if boid.is_touching_water and duck_animation_player.current_animation != "Arm_duck|swim":
		duck_animation_player.play("Arm_duck|swim")
	
	# Check if duck arrived then change state to a land state
	var distance_to_target = boid.global_transform.origin.distance_to(lake_point.global_transform.origin)

	if distance_to_target < 15:
		boid.get_node("StateMachine").change_state(Swim.new())

func _exit():
	boid.set_enabled(boid.get_node("Seek"), false)

func constrain_to_water_level():
	# Constrain the y-coordinate to the water level
	var position = boid.global_transform.origin
	position.y = -0.25
	boid.global_transform.origin = position


