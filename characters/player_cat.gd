extends CharacterBody2D

@export var Bullet : PackedScene

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)

var aiming = false :
	get:
		return aiming
	set(value):
		pick_new_state()
		aiming = value

var shoot_timer : Timer
@export var shoot_delay : float = 1.0
@export var min_shoot_delay : float = 0.1
var shoot_ready = true
var bullet_damage = 1
@export var max_bullet_damage = 4

@export var recharge_delay : float = 3.0
@export var max_ammo : int = 6
var curr_ammo = max_ammo
var recharging = false
var recharge_timer : Timer
signal recharge_started
signal recharge_ended

# Max buffs reached
signal max_damage_reached
signal max_atk_spd_reached
signal max_ammo_reached

# Specials buffs active
var buff_ak47_active : bool = false

# parameters/idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func set_sr_true():
	shoot_ready = true
	
func setup_shoot_timer():
	if not shoot_timer:
		shoot_timer = Timer.new()
		add_child(shoot_timer)
	shoot_timer.stop()
	shoot_timer.wait_time = shoot_delay
	shoot_timer.one_shot = true
	shoot_timer.start()
	shoot_timer.connect("timeout", set_sr_true)
	
func _ready():
	setup_shoot_timer()
	update_animation_parameters(starting_direction)
	Global.upgrade_function = buff_status
	
func _physics_process(delta):
	# Get Input Direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	update_animation_parameters(input_direction)
	
	# Update velocity
	velocity = input_direction * move_speed
	if aiming:
		velocity -=50*input_direction
	pick_new_state()
	
	# Move and Slide function uses velocity of character body to move character or
	move_and_collide(velocity * delta)
	
	if Input.get_action_strength("shoot") != 0:
		shoot()

func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO) :
		animation_tree.set("parameters/idle/blend_position", move_input.x)
		animation_tree.set("parameters/walk/blend_position", move_input.x)
		animation_tree.set("parameters/shoot/blend_position", move_input.x)
		animation_tree.set("parameters/aim/blend_position", move_input.x)
		
func pick_new_state():
	if (velocity != Vector2.ZERO):
		if aiming:
			state_machine.travel("aim")
		else:
			state_machine.travel("walk")
	else:
		state_machine.travel("idle")

func shoot():
	if shoot_ready and !recharging:
		var b = Bullet.instantiate()
		add_child(b)
		b.transform = $Marker2D.transform
		if !aiming:
			b.random_value = (randf()/5-0.1)*PI
		b.start(bullet_damage)
		curr_ammo -= 1
		if curr_ammo <= 0:
			start_recharging()
		shoot_ready = false
		shoot_timer.start()

func start_recharging():
	recharging = true
	if not recharge_timer:
		recharge_timer = Timer.new()
		recharge_timer.one_shot = true
		add_child(recharge_timer)
	recharge_timer.stop()
	recharge_timer.wait_time = recharge_delay
	recharge_timer.start()
	recharge_timer.connect("timeout", recharge)
	$RechargeLabel.visible = true
	recharge_started.emit()
	
func recharge():
	curr_ammo = max_ammo
	recharging = false
	$RechargeLabel.visible = false
	recharge_ended.emit()
	
func on_damage_took():
	pass
	
func die():
	queue_free()

func _input(event):
	if event.is_action_pressed("aim"):
		aiming = true
	if event.is_action_released("aim"):
		aiming = false
	
func _on_combat_life_controller_taken_damage():
	pass

func buff_damage():
	if bullet_damage < max_bullet_damage:
		bullet_damage += 1
	else:
		Global.max_upgraded.append("damage")
		Global.special_upgrades.append("penetrating")
		max_damage_reached.emit()

func buff_atk_speed():
	if shoot_delay > min_shoot_delay:
		shoot_delay *= 0.5
		setup_shoot_timer()
	else:
		Global.max_upgraded.append("atk_speed")
		Global.special_upgrades.append("ak47")
		max_atk_spd_reached.emit()
	
func buff_ammo():
	max_ammo *= 2
	curr_ammo = max_ammo

func buff_armor():
	var clc = $CombatLifeController
	clc.max_hp += 2
	clc.curr_hp = clc.max_hp
	
func buff_ak47():
	shoot_delay = 0.05
	setup_shoot_timer()
	buff_ak47_active = true
	Global.max_upgraded.append("ak47")
	
func buff_status(type_of_buff : String):
	match type_of_buff:
		"damage":
			buff_damage()
		"atk_speed":
			buff_atk_speed()
		"ammo":
			buff_ammo()
		"armor":
			buff_armor()
		"penetrating":
			pass
		"double_atk":
			pass
		"ak47":
			buff_ak47()
	print(type_of_buff + " buff executed")
