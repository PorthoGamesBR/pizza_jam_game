extends Node

class Item:
	var name : String = "Item" 
	var price : int = 0
	var sprite_id : int = 0
	func _init(it_name: String, it_price: int, spr_id: int):
		name = it_name
		price = it_price
		sprite_id = spr_id


var items_list = {
	0: Item.new("Celular",10,0),
	1: Item.new("Colete Fungado",100,1),
	2: Item.new("Colete",150,2),} :
	get:
		pass
	set(val):
		pass
		
func get_item_from_id(id) -> Item:
	return items_list[id]
	
var inventory = []
