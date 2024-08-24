extends Node3D

# AudioPlayer1 source url: https://www.youtube.com/watch?v=aFQoM1JhzQY
# AudioPlayer2 source url: https://www.youtube.com/watch?v=2Xy9NjGfJZo
# AudioPlayer3 source url: https://www.youtube.com/shorts/rVEaanykP2I
# AudioPlayer4 source url: https://www.youtube.com/shorts/PF4XIHLYQRA

var boid
var quack_timer
var duck_state_machine
var audio_players = []

func _ready():
	boid = get_parent()
	audio_players = self.get_children()
	duck_state_machine = get_node("../StateMachine")
	
	# Set up the timer for random state change
	quack_timer = Timer.new()
	add_child(quack_timer)
	quack_timer.one_shot = false
	quack_timer.connect("timeout", Callable(self, "_noise_timeout"))
	reset_quack_timer()

func play_random_sound():
	if audio_players.size() > 0:
		# Selecting random AudioStreamPlayer3D node
		var random_index = randi() % audio_players.size()
		var random_player = audio_players[random_index]
		
		random_player.play()

func reset_quack_timer():
	quack_timer.start(randf_range(0, 20.0)) 

func _noise_timeout():
	if should_make_noise():
		play_random_sound()
	
	reset_quack_timer()

func should_make_noise():
	var duck_current_state = duck_state_machine.current_state
	
	if duck_current_state is Sleep:
		return false
	else:
		return randf() < 0.1
