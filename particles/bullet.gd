extends CharacterBody2D

@export var speed = 750

func _ready():
	velocity = Vector2(speed,0)
	
func _physics_process(delta):
	move_and_collide(velocity * delta)

func _on_does_damage_contacted_solid():
	queue_free()
