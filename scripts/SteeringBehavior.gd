class_name SteeringBehavior extends Node

@export var weight = 1.0

var boid

@export var enabled = true: get = is_enabled, set = set_enabled

func set_enabled(e):
	enabled = e 
	set_process(enabled)

func is_enabled():
	return enabled
	
func on_draw_gizmos():
	pass
	
func _process(delta):	
	pass
