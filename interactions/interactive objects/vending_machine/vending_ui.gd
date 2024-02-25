extends Control

@export var shop_item : PackedScene
@onready var panel = $Panel/ShopMenu

@onready var armor_button = $Panel/Armor


func _ready():
	hide()
	

func _process(delta):
	_set_cash_text()
	
func _input(event):
	if event.is_action_pressed("interact") && get_tree().paused:
		hide()
		get_tree().paused = false
	if event.is_action_pressed("pause"):
		hide()

	
func _set_cash_text():
	$Panel/Cash.text = str("Cash:",Global.money)

func _set_sell_items():
	for n in panel.get_children():
		panel.remove_child(n)
		n.queue_free()
		
	for item in Global.inventory:
		var si = shop_item.instantiate()
		panel.add_child(si)
		si.it_name = item.name
		si.it_price = item.price
		si.sprite_id = item.sprite_id
		si.on_sell = _sell_item
	
func _sell_item(_item_name):
	var item
	var index = -1
	for i in Global.inventory:
		index += 1
		if i.name == _item_name:
			item = i
			break
	Global.remove_from_inventory(index)
	Global.money += item.price
	_set_sell_items()

func configure_ui():
	_set_sell_items()
	
func _on_close_pressed():
	hide()
	get_tree().paused = false
