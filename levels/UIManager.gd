extends Node2D

@export var player : CharacterBody2D
@export var life_ui : Control
var life_controller

func set_life_vars():
	life_ui.max_life = life_controller.max_hp
	life_ui.curr_life = life_controller.curr_hp
	
func _ready():
	life_controller = player.get_node("CombatLifeController")
	
func _process(delta):
	if not Global.player_died:
		set_life_vars()
