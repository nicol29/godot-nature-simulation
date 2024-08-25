extends Control

# Using signals in combination with a singleton pattern
func _on_cohesion_slider_value_changed(value):
	GameSettings.cohesion_weight = value


func _on_alignment_slider_value_changed(value):
	GameSettings.alignment_weight = value


func _on_seperation_slider_value_changed(value):
	GameSettings.separation_weight = value


func _on_max_speed_slider_value_changed(value):
	GameSettings.max_speed = value
