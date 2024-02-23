extends Node2D

class_name GameManager

signal toggle_game_paused(is_paused:bool)

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		if(game_paused == value):
			game_paused = !value
		else:
			game_paused = value
		emit_signal("toggle_game_paused", game_paused)
		get_tree().paused = game_paused

func _input(event):
	if event.is_action_pressed("pause"):
		game_paused = !get_tree().paused
