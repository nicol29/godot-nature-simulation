class_name Swim extends State

var boid
@export var water:NodePath
@export var target:Node3D

var timer
var duck_animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	
	duck_animation_player = get_node("../Sketchfab_Scene/AnimationPlayer")

func _enter():
	duck_animation_player.play("Arm_duck|swim")
	
	# Enable flocking behavior when ducks are swimming
	for behavior in boid.behaviors:
		if behavior is Wander or behavior is Seek:
		# Disable Wander and Seek
			boid.set_enabled(behavior, false)
		else:
		# Enable other behaviors
			boid.set_enabled(behavior, true)

func _think():
	var current_speed = boid.vel.length()
	
	# Clamp the duck's swim animation speed based on it's vel
	if duck_animation_player.is_playing():
		duck_animation_player.speed_scale = clamp(current_speed, 0.2, 1.0)

func _exit():
	pass
