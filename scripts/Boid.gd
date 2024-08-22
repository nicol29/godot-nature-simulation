class_name Boid extends CharacterBody3D

@export var mass = 1
@export var force = Vector3.ZERO
@export var acceleration = Vector3.ZERO
@export var vel = Vector3.ZERO
@export var speed:float
@export var max_speed: float = 2
@export var max_force = 5
@export var damping = 0.1
@export var pause = false


var behaviors = [] 
var count_neighbors = false
var neighbors = [] 
var flock = null
var new_force = Vector3.ZERO
var should_calculate = false


var is_touching_water: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	# Check for a variable
	if "partition" in get_parent():
		flock = get_parent()
	
	for i in get_child_count():
		var child = get_child(i)
		if child.has_method("calculate"):
			behaviors.push_back(child)
			child.set_process(child.enabled)


func _process(delta):
	should_calculate = true
	# pause = false
	if flock and count_neighbors:
		count_neighbors_simple()
	
	is_touching_water = detect_if_touching_water()


func _physics_process(delta):
	# pause = true
	# lerp in the new forces
	if should_calculate:
		new_force = calculate()
		should_calculate = false		
	force = lerp(force, new_force, delta)
	if ! pause:
		acceleration = force / mass
		vel += acceleration * delta
		
		# Constrain velocity to the XZ plane
		vel.y = 0
		
		speed = vel.length()
		if speed > 0:		
			if max_speed == 0:
				print("max_speed is 0")
			vel = vel.limit_length(max_speed)
			
			# Damping
			vel -= vel * delta * damping
			
			set_velocity(vel)
			move_and_slide()
			
			var smoothed_direction = lerp(-global_transform.basis.z, vel, 0.1)
			look_at(global_transform.origin - vel.normalized(), Vector3.UP)
	
func count_neighbors_simple():
	neighbors.clear()
	for i in flock.boids.size():
		var boid = flock.boids[i]
		if boid != self and global_transform.origin.distance_to(boid.global_transform.origin) < flock.neighbor_distance:
			neighbors.push_back(boid)
			if neighbors.size() == flock.max_neighbors:
				break
	return neighbors.size()

func set_enabled(behavior, enabled):
	behavior.enabled = enabled
	behavior.set_process(enabled)

func seek_force(target: Vector3):	
	var toTarget = target - global_transform.origin
	toTarget.y = 0
	toTarget = toTarget.normalized()
	var desired = toTarget * max_speed
	return desired - vel
	
func arrive_force(target:Vector3, slowingDistance:float):
	var toTarget = target - global_transform.origin
	var dist = toTarget.length()
	toTarget.y = 0
	if dist < 2:
		return Vector3.ZERO
	
	var ramped = (dist / slowingDistance) * max_speed
	var limit_length = min(max_speed, ramped)
	var desired = (toTarget * limit_length) / dist 
	return desired - vel

func set_enabled_all(enabled):
	for i in behaviors.size():
		behaviors[i].enabled = enabled
		
func update_weights(weights):
	for behavior in weights:
		var b = get_node(behavior)
		if b: 
			b.weight = weights[behavior]

func calculate():
	var force_acc = Vector3.ZERO	
	var behaviors_active = ""
	for i in behaviors.size():
		if behaviors[i].enabled:
			var f = behaviors[i].calculate() * behaviors[i].weight
			if is_nan(f.x) or is_nan(f.y) or is_nan(f.z):
				print(str(behaviors[i]) + " is NAN")
				f = Vector3.ZERO
			behaviors_active += behaviors[i].name + ": " + str(round(f.length())) + " "
			force_acc += f 
			if force_acc.length() > max_force:
				force_acc = force_acc.limit_length(max_force)
				behaviors_active += " Limiting force"
				break
	return force_acc


func detect_if_touching_water() -> bool:
	# Extend a ray from the duck's pos to check if it is in water
	var from = self.global_transform.origin
	var to = from - Vector3(0, 0.5, 0) 
	var query = PhysicsRayQueryParameters3D.create(from, to, self.collision_mask)
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	
	# Check if the collider's group name is "water"
	if result and result.collider.is_in_group("water"):
		return true
	return false
