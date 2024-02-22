extends Area2D

@export var damage = 1
@export var damagable_group = "inimigo"

signal contacted_solid
signal applied_damage

func _physics_process(delta):
	if has_overlapping_bodies():
		on_collision(get_overlapping_bodies()[0])
		
func on_collision(body):
	if body.is_in_group(damagable_group):
		var clc = body.get_node("CombatLifeController")
		if clc:
			clc.take_damage(damage)
			applied_damage.emit()
	contacted_solid.emit()
