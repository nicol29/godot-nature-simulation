class_name StateMachine extends Node

var initial_state

var current_state:State
var previous_state:State
var state_change_timer

var boid


func _ready():
	boid = get_parent()
	initial_state = assign_initial_state()
	
	if initial_state:
		current_state = initial_state
		current_state.call_deferred("_enter")
	
	# Set up the timer for random state change
	state_change_timer = Timer.new()
	add_child(state_change_timer)
	state_change_timer.one_shot = true
	state_change_timer.connect("timeout", Callable(self, "_on_state_change_timeout"))
	reset_state_change_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state._think()

func assign_initial_state():
	if boid.did_spawn_in_lake:
		return boid.get_node("Swim")
	else:
		var random_value = randi() % 2 
		
		if random_value == 0:
			return boid.get_node("Sleep")
		else:
			return boid.get_node("Walk")

func change_state(new_state):
	if current_state:
		current_state._exit()
		boid.call_deferred("remove_child", current_state);
	current_state = new_state
	if current_state:
		boid.add_child(current_state);
		current_state._enter()

func reset_state_change_timer():
	# Start timer with random duration to ensure not all boids change state at the same time
	state_change_timer.start(randf_range(5.0, 15.0)) 

func should_change_state() -> bool:
	return randf() < 0.8 

func _on_state_change_timeout():
	if should_change_state():
		var next_state = determine_next_state()
		# Only change if the new state is different to the current one
		if next_state != current_state:
			change_state(next_state)
	# Reset the timer for the next possible state change
	reset_state_change_timer()

func determine_next_state():
	if current_state is Swim:
		if randf() < 0.1:  # 10% chance to move to shore
			return boid.get_node("SwimToShore")
	elif current_state is Walk:
		if randf() < 0.9:  # 90% chance to move to water
			return boid.get_node("ReturnToPond")
			
	return current_state
