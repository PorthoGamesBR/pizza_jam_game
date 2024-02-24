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

var shoot_timer
@export var shoot_delay : float = 1.0
var shoot_ready = true

# parameters/idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func set_sr_true():
	shoot_ready = true
	
func setup_shoot_timer():
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = shoot_delay
	shoot_timer.one_shot = true
	shoot_timer.start()
	shoot_timer.connect("timeout", set_sr_true)
	
func _ready():
	setup_shoot_timer()
	
	update_animation_parameters(starting_direction)
	
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
	if shoot_ready:
		var b = Bullet.instantiate()
		add_child(b)
		b.transform = $Marker2D.transform
		if !aiming:
			b.random_value = (randf()/5-0.1)*PI
		b.start()
		shoot_ready = false
		shoot_timer.start()

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
