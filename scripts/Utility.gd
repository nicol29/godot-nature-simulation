class_name Utility extends Node


static func get_random_position_inside_circle(center: Vector3, radius: float) -> Vector3:
	var angle = randf() * PI * 2
	var distance = randf() * radius
	var position = Vector3(
		center.x + cos(angle) * distance,
		center.y,  
		center.z + sin(angle) * distance
	)
	return position
