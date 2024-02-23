extends CharacterBody2D

@export var speed = 750
@export var direction : Vector2 = Vector2(1,1)

func _ready():
	velocity = direction * speed
	direction = (get_global_mouse_position() - get_position_delta()).normalized()

func _physics_process(delta):
	move_and_collide(velocity * delta * direction)

func _on_does_damage_contacted_solid():
	queue_free()
