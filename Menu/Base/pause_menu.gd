extends Control

@export var game_manager: GameManager

func _ready():
	hide()
	game_manager.connect("toggle_game_paused", on_game_manager_toogle_game_paused)

func on_game_manager_toogle_game_paused(is_paused:bool):
	if is_paused:
		show()
	else:
		hide()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/game_level.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Menu/Base/options_menu.tscn")
