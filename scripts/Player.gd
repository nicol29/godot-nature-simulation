extends CharacterBody3D

@onready var CameraRef: Camera3D = self.get_node("./Camera3D")

@export var SPEED = 10
@export var mouse_sensitivity = 0.15


func _ready():
	# Lock the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion and not Input.is_action_pressed("break_mouse"):
		_rotate_camera(event)

func _physics_process(delta):
	# Moving the player
	var input_dir = Input.get_vector("right", "left", "backward", "forward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_pressed("ascend"):
		velocity.y = SPEED
	elif Input.is_action_pressed("descend"):
		velocity.y = -SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()

func _process(delta):
	# If button for breaking mouse focus is held change the mouse mode to visible
	if Input.is_action_pressed("break_mouse"):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _rotate_camera(event):
	# Set the rotation of the player on its y axis when looking left/right
	rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
	
	# Set the rotation of the player's camera when looking up or down
	if CameraRef:
		var new_pitch = CameraRef.rotation_degrees.x - event.relative.y * mouse_sensitivity
		# Clamp to ensure camera doesnt rotate backwards
		CameraRef.rotation_degrees.x = clamp(new_pitch, -90, 90)
