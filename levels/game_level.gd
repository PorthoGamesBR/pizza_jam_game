extends Node2D

var player_on_bus : bool = true
var create_timer : Timer
var plr_origin_spd : float
var origin_player_pos : Vector2
var starting : bool = false

func _ready():
	origin_player_pos = Global.player.position
	create_timer = Timer.new()
	add_child(create_timer)
	create_timer.one_shot = true
	create_timer.wait_time = 3
	create_timer.timeout.connect(end_start_new_level)
	
func _process(delta):
	if new_level_condition() and not starting:
		start_new_level()

func new_level_condition():
	return Global.enemy_ammount == 0 and player_on_bus
	
func start_new_level():
	starting = true
	plr_origin_spd = Global.player.move_speed
	Global.player.move_speed = 0
	create_timer.start()
	print("started")

func end_start_new_level():
	$TileMap._ready()
	Global.player.move_speed = plr_origin_spd
	Global.player.position = origin_player_pos
	starting = false
	print("ended")

func player_entered_bus():
	player_on_bus = true
	
func player_exited_bus():
	player_on_bus = false

func _on_area_2d_body_entered(body):
	player_entered_bus()


func _on_area_2d_body_exited(body):
	player_exited_bus()
