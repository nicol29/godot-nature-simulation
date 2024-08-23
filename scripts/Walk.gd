class_name Walk extends State

var boid
var timer
var duck_animation_player: AnimationPlayer
var roaming_area: Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	
	# Get the animation player
	duck_animation_player = get_node("../Sketchfab_Scene/AnimationPlayer")
	
	timer = Timer.new()
	add_child(timer)	
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "timeout"))

func timeout():
	# Disable boid's movement to play eat animation
	boid.pause = true
	duck_animation_player.play("Arm_duck|eat")

func _enter():
	# Disable flocking and other behaviors unless it's wander
	for behavior in boid.behaviors:
		if not behavior is Wander:
			boid.set_enabled(behavior, false)
		else:
			boid.set_enabled(behavior, true)
			
	# Play walk animation
	duck_animation_player.play("Arm_duck|walk")
	
	# Start timer
	var sleep_duration = randf_range(5, 10)
	timer.start(sleep_duration)
	
	# Set wander behavior's target
	roaming_area = boid.global_transform.origin
	var wander_behavior = boid.get_node("Wander")
	wander_behavior.set_target(roaming_area)

func _think():
	# Check if duck is on land and if so switch to walk animation
	if boid.pause and not duck_animation_player.is_playing():
		# Resume duck's movement
		boid.pause = false
		duck_animation_player.play("Arm_duck|walk")

func _exit():
	boid.set_enabled(boid.get_node("Wander"), false)
	
	#boid.vel = Vector3.ZERO
	#boid.force = Vector3.ZERO
