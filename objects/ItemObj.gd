extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var item_data : Global.Item
var rng = RandomNumberGenerator.new()

func start_item():
	var rand_id = rng.randi_range(0, Global.get_size_item_ls()-1)
	item_data = Global.get_item_from_id(rand_id)
	sprite.play(str(item_data.sprite_id))
	
func collect_item():
	Global.add_item_inventory(item_data)
	var to_print = []
	for i in Global.inventory:
		to_print.append(i.name)
	print(to_print)
	queue_free()
	
func _ready():
	interaction_area.is_active = true
	start_item()
	interaction_area.action_name = "collect " + item_data.name
	interaction_area.interact = collect_item
