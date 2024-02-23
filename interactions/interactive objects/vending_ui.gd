extends Control

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("interact") && get_tree().paused:
		hide()
		get_tree().paused = false
	if event.is_action_pressed("pause"):
		hide()


func _on_close_pressed():
	hide()
	get_tree().paused = false
