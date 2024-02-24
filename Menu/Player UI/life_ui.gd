extends Control

@onready var life_txt = $Label

var max_life = 20
var curr_life = 20

func _process(delta):
	life_txt.text = str("HP:",curr_life,"|",max_life)
