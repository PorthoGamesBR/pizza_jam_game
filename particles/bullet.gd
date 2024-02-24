extends CharacterBody2D

@export var speed = 750
@export var direction : Vector2 = Vector2(1,1)
@export var random_value: float = 0

var is_ready = false

func set_random_value(value:float):
	random_value = value

func start():
	is_ready = true
	velocity = direction * speed
	direction = (get_global_mouse_position() - get_position_delta()).normalized()
	direction = direction.rotated(random_value)
	print(direction)

func _physics_process(delta):
	if is_ready:
		move_and_collide(velocity * delta * direction)

func _on_does_damage_contacted_solid():
	queue_free()
