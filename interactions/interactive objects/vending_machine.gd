extends Node2D

@onready var interaction_area: InteractionArea = $InteractiveArea
# Called when the node enters the scene tree for the first time.
func _ready():
	print("teste")
	interaction_area.interact = Callable(self, "_open_menu")

func _open_menu():
	print("teste")
