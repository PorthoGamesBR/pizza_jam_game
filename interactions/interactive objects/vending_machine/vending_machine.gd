extends Node2D

var is_open = false

@onready var interaction_area: InteractionArea = $InteractiveArea
@onready var vendingUI: Control = $CanvasLayer/VendingUi
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_open_menu")
	interaction_area.on_body_entered = Callable(self, "_open_animation")
	interaction_area.on_body_exited = Callable(self, "_close_animation")

@export var is_active: bool = true :
	get:
		return is_active
	set(value):
		interaction_area.is_active = value
		is_active = value

func _open_menu():
	vendingUI.show()
	get_tree().paused = true
	var is_open = true
	
func _open_animation():
	state_machine.travel("Openning")
	
func _close_animation():
	state_machine.travel("Closening")
