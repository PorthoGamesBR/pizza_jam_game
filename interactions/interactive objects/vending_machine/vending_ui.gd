extends Control

@export var shop_item : PackedScene
@onready var panel = $Panel/ShopMenu

var player_items = []
var ui_cash = 0

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("interact") && get_tree().paused:
		hide()
		get_tree().paused = false
	if event.is_action_pressed("pause"):
		hide()

func _load_data():
	player_items = []
	for i in Global.inventory:
		player_items.append(i)
	
func _set_cash():
	$Panel/Cash.text = str("Cash:",ui_cash)

func _set_sell_items():
	for n in panel.get_children():
		panel.remove_child(n)
		n.queue_free()
		
	for item in player_items:
		var si = shop_item.instantiate()
		panel.add_child(si)
		si.it_name = item.name
		si.it_price = item.price
		si.sprite_id = item.sprite_id
		si.on_sell = _sell_item
	
func _sell_item(_item_name):
	var item
	var index = -1
	for i in player_items:
		index += 1
		if i.name == _item_name:
			item = i
			break
	Global.remove_from_inventory(index)
	ui_cash += item.price
	_set_cash()
	player_items.remove_at(index)
	_set_sell_items()
	
func configure_ui():
	_load_data()
	_set_cash()
	_set_sell_items()
	

func _on_close_pressed():
	hide()
	get_tree().paused = false
