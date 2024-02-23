extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass
var on_body_entered: Callable = func():
	pass
var on_body_exited: Callable = func():
	pass


func _on_body_entered(_body):
	on_body_entered.call()
	InteractionManager.register_area(self)


func _on_body_exited(_body):
	on_body_exited.call()
	InteractionManager.unregister_area(self)
