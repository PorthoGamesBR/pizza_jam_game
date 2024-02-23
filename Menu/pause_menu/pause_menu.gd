extends Control

@export var game_manager: GameManager

func _ready():
	hide()
	game_manager.toggle_game_paused.connect(on_game_manager_toogle_game_paused)

func on_game_manager_toogle_game_paused(is_paused:bool):
	if is_paused:
		show()
	else:
		hide()

func _on_exit_pressed():
	game_manager.game_paused = !get_tree().paused
	get_tree().change_scene_to_file("res://Menu/Base/base_menu.tscn")

func _on_resume_pressed():
	game_manager.game_paused = !get_tree().paused
