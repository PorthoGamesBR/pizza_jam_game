extends Node2D

@export var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_does_damage_contacted_solid():
	queue_free()
