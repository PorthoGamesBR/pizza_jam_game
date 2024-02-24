extends Node
class_name Global

class Item:
	var name : String = "Item" 
	var price : int = 0
	var sprite_id : int = 0
	func _init(it_name: String, it_price: int, spr_id: int):
		name = it_name
		price = it_price
		sprite_id = spr_id


static var _items_list = {
	0: Item.new("Celular",10,0),
	1: Item.new("Colete Fungado",100,1),
	2: Item.new("Colete",150,2),} :
	set(val):
		pass
		
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
