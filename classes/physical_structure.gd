class_name PhysicalStructure

# Add properties
@export var id : int = 1
@export var name : String = "smallTree"
@export var height :int= 4
@export var width :int= 3
@export var qtd :int= 1

func _init(_id:int, _name:String, _height:int, _width:int, _qtd:int):
	id = _id
	name = _name
	height = _height
	width = _width
	qtd = _qtd
