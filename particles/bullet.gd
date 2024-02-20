extends Area2D

@export var speed = 750
@export var damage = 1

func _physics_process(delta):
	position += transform.x * speed * delta
	if has_overlapping_bodies():
		on_collision(get_overlapping_bodies()[0])
		
func on_collision(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
