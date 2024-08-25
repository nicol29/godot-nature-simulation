extends Control

@onready var cohesion_slider = $"./ColorRect/MarginContainer/VBoxContainer/Cohesion/CohesionSlider"
@onready var alignment_slider = $"./ColorRect/MarginContainer/VBoxContainer/Alignment/AlignmentSlider"
@onready var separation_slider = $"./ColorRect/MarginContainer/VBoxContainer/Separation/SeparationSlider"
@onready var max_speed_slider = $"./ColorRect/MarginContainer/VBoxContainer/MaxSpeed/MaxSpeedSlider"

@onready var cohesion_label = $"./ColorRect/MarginContainer/VBoxContainer/Cohesion/Label"
@onready var alignment_label = $"./ColorRect/MarginContainer/VBoxContainer/Alignment/Label"
@onready var separation_label = $"./ColorRect/MarginContainer/VBoxContainer/Separation/Label"
@onready var max_speed_label = $"./ColorRect/MarginContainer/VBoxContainer/MaxSpeed/Label"

var default_cohesion_val := 1.0
var default_alignment_val := 1.0
var default_separation_val := 1.0
var default_max_speed_val := 1.0

func _ready():
	cohesion_label.text = "Cohesion: " + str(default_cohesion_val)
	alignment_label.text = "Alignment: " + str(default_alignment_val)
	separation_label.text = "Separation: " + str(default_separation_val)
	max_speed_label.text = "Max Speed: " + str(default_max_speed_val)

# Using signals in combination with a singleton pattern
func _on_cohesion_slider_value_changed(value):
	GameSettings.cohesion_weight = value
	update_label_text(cohesion_label, "Cohesion", value)

func _on_alignment_slider_value_changed(value):
	GameSettings.alignment_weight = value
	update_label_text(alignment_label, "Alignment", value)

func _on_seperation_slider_value_changed(value):
	GameSettings.separation_weight = value
	update_label_text(separation_label, "Seperation", value)

func _on_max_speed_slider_value_changed(value):
	GameSettings.max_speed = value
	update_label_text(max_speed_label, "Max Speed", value)


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


func update_label_text(label: Label, label_text: String, value: float):
	label.text = label_text + ": " + str(value)
