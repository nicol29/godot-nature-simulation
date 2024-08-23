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

static func random_point_in_unit_disk() -> Vector3:
	var theta = randf_range(0, 2 * PI)
	var r = sqrt(randf_range(0, 1)) 

	var x = r * cos(theta)
	var z = r * sin(theta)
	
	return Vector3(x, 0, z)
