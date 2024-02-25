extends Node
class_name Global

static var player: CharacterBody2D

class Item:
	var name : String = "Item" 
	var price : int = 0
	var sprite_id : int = 0
	func _init(it_name: String, it_price: int, spr_id: int):
		name = it_name
		price = it_price
		sprite_id = spr_id


static var money = 0
static var upgrade_function : Callable = func(_upgrade_type): pass
static var max_upgraded = []
static var special_upgrades = []

static var _items_list = {
	0: Item.new("Celular",10,0),
	1: Item.new("Colete Fungado",100,1)} :
	set(val):
		pass
		
static var colete_upgrade = _items_list[1]
	
static func get_item_from_id(id) -> Item:
	return _items_list[id]
	
static func get_size_item_ls() -> int:
	return _items_list.size()
	
static var inventory = []:
	get:
		return inventory
	set(val):
		pass

static func add_item_inventory(item: Item):
	inventory.append(item)

static func remove_from_inventory(id: int):
	inventory.remove_at(id)

