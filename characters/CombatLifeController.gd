extends Node

# Combat status control
@export var max_hp : int = 3
var curr_hp = max_hp

signal taken_damage
signal died

func _ready():
	curr_hp = max_hp

func take_damage(damage):
	var dmg = damage
	curr_hp -= dmg
	taken_damage.emit()
	if (curr_hp <= 0):
		died.emit()
