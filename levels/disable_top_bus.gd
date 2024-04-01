extends Area2D

@export var tilemap : TileMap

var full_color = Color(1,1,1,1)
var empty_color = Color(1,1,1,0)

func change_top_opacity(clear):
	if clear:
		tilemap.set_layer_modulate(2, empty_color)
	else:
		tilemap.set_layer_modulate(2, full_color)


func _on_body_entered(body):
	print("Entrou no busao")
	change_top_opacity(true)


func _on_body_exited(body):
	print("Saiu do busao")
	change_top_opacity(false)
