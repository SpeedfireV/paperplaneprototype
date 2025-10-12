extends Node

signal game_paused_changed(is_paused: bool)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if Input.is_action_just_pressed("pause"):
		pause_game()


func pause_game():
	if get_tree().paused:
		get_tree().paused = false
	else:
		get_tree().paused = true

	game_paused_changed.emit(not get_tree().paused)