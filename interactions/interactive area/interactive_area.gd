extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"
@export var is_active = true
@export var font_size = 13

var interact: Callable = func():
	pass
var on_body_entered: Callable = func():
	pass
var on_body_exited: Callable = func():
	pass

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(_body):
	if is_active:
		on_body_entered.call()
		InteractionManager.register_area(self)

func _on_body_exited(_body):
	on_body_exited.call()
	InteractionManager.unregister_area(self)
