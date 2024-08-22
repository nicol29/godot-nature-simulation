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
	

func _enter():
	duck_animation_player.play("Arm_duck|sleep_start")
	print("Entered sleep state")
	   
	var sleep_duration = randf_range(5, 10)
	timer.start(sleep_duration)

func _think():
	# Check if the animation has stopped playing
	if not duck_animation_player.is_playing():
		print("The walk animation has stopped playing.")
		duck_animation_player.play("Arm_duck|sleep")

func _exit():
	pass
