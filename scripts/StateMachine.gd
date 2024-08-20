class_name StateMachine extends Node

var initial_state
@export var global_state_path:NodePath

var current_state:State
var global_state:State
var previous_state:State

var boid

	
func _ready():
	boid = get_parent()
	initial_state = assign_random_state()
	
	if initial_state:
		current_state = initial_state
		current_state.call_deferred("_enter")
		current_state._enter()
	if global_state_path:
		global_state = get_node(global_state_path)
		# Ready may not have been called!
		global_state.call_deferred("_enter")
		# current_state._enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state._think()
	if global_state:
		global_state._think()

func change_state(new_state):
	print(str(boid) + "\t" + new_state.get_class())
	if current_state:
		current_state._exit()
		boid.call_deferred("remove_child", current_state);
	current_state = new_state
	if current_state:
		boid.add_child(current_state);
		current_state._enter()

func should_change_state() -> bool:
	# Implement your timing or random logic here
	return randf() < 0.01  # Example: 1% chance per frame to change state


func assign_random_state():
	var state_weights = {
		boid.get_node("Swim"): 1,   # 60% chance
		#"ShoreFlockState": 0.2,  # 20% chance
		#"MoveToShoreState": 0.1, # 10% chance
		#"RestState": 0.1         # 10% chance
	}

	var rand_value = randf()
	var cumulative = 0.0
	for state in state_weights.keys():
		cumulative += state_weights[state]
		if rand_value < cumulative:
			return state

