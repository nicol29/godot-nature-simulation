class_name Sleep extends State

var boid
var duck_animation_player
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	# Get the animation player
	duck_animation_player = get_node("../Sketchfab_Scene/AnimationPlayer")
	
	timer = Timer.new()
	add_child(timer)	
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "timeout"))

func timeout():
	duck_animation_player.play("Arm_duck|sleep_end")
	
	var random_value = randi() % 2 
	if random_value == 0:
		boid.get_node("StateMachine").change_state(Walk.new())
	else:
		boid.get_node("StateMachine").change_state(ReturnToPond.new())

func _enter():
	duck_animation_player.play("Arm_duck|sleep_start")
	
	# Disable boid movement went sleeping
	boid.pause = true
	
	var sleep_duration = randf_range(45, 100)
	timer.start(sleep_duration)

func _think():
	if not duck_animation_player.is_playing():
		duck_animation_player.play("Arm_duck|sleep")

func _exit():
	# Re-enable movement
	boid.pause = false
