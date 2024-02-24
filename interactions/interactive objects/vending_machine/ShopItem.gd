extends VBoxContainer

var on_sell : Callable = func():
	pass

var sprite_id : int :
	set(val):
		sprite_id = val
		$HBoxContainer/AnimatedSprite2D.play(str(val))

var it_name : String:
	set(val):
		it_name = val
		$HBoxContainer/VBoxContainer/Nome.text = val

var it_price : int:
	set(val):
		it_price = val
		$HBoxContainer/VBoxContainer/Preco.text = str("+$",val)


func _on_preco_pressed():
	on_sell.call(it_name)
