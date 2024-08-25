extends Control

@onready var cohesion_slider = $"./ColorRect/MarginContainer/VBoxContainer/Cohesion/CohesionSlider"
@onready var alignment_slider = $"./ColorRect/MarginContainer/VBoxContainer/Alignment/AlignmentSlider"
@onready var separation_slider = $"./ColorRect/MarginContainer/VBoxContainer/Separation/SeparationSlider"
@onready var max_speed_slider = $"./ColorRect/MarginContainer/VBoxContainer/MaxSpeed/MaxSpeedSlider"

var default_cohesion_val := 1.0
var default_alignment_val := 1.0
var default_separation_val := 1.0
var default_max_speed_val := 1.0

# Using signals in combination with a singleton pattern
func _on_cohesion_slider_value_changed(value):
	GameSettings.cohesion_weight = value


func _on_alignment_slider_value_changed(value):
	GameSettings.alignment_weight = value


func _on_seperation_slider_value_changed(value):
	GameSettings.separation_weight = value


func _on_max_speed_slider_value_changed(value):
	GameSettings.max_speed = value


func _on_button_pressed():
	reset_input_values()


func reset_input_values():
	# Resetting global script's default value settings
	GameSettings.cohesion_weight = default_cohesion_val
	GameSettings.alignment_weight = default_cohesion_val
	GameSettings.separation_weight = default_separation_val
	GameSettings.max_speed = default_max_speed_val
	
	# Resetting sliders value
	cohesion_slider.value = default_cohesion_val
	alignment_slider.value = default_alignment_val
	separation_slider.value = default_separation_val
	max_speed_slider.value = default_max_speed_val
