extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)

# parameters/idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var timer = $WalkTimer
@onready var sprite = $Sprite2D

@onready var life_controller = $CombatLifeController

var rng = RandomNumberGenerator.new()
var walk = 0
var direction = Vector2()

@onready var attack_controler = $DoesDamage
var attack_timer
@export var attack_delay : float = 1.5
@export var attack_ready = true

@export var ItemObj : PackedScene

func set_atk_false():
	# print("Chicken Attack is now false")
	attack_controler.damage_is_active = false
	attack_ready = false
	attack_timer.start()
	
func set_atk_true():
	# print("Chicken Attack is now true")
	attack_controler.damage_is_active = true
	attack_ready = true
	
func trigger_attack_animation():
	print("Attack")
	state_machine.travel("attack")
	
func setup_attack_timer():
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = attack_delay
	attack_timer.one_shot = true
	attack_timer.start()
	attack_timer.connect("timeout", set_atk_true)
	attack_controler.applied_damage.connect(set_atk_false)
	attack_controler.applied_damage.connect(trigger_attack_animation)

func _ready():
	setup_attack_timer()
	
	var cw = func check_walk() :
		# print("Randomizing movement option")
		walk = rng.randi_range(0, 1)
		direction = Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
	
	timer.connect("timeout", cw)
	life_controller.died.connect(die)
	
func _physics_process(delta):
# Update velocity
	if (attack_ready):
		velocity = direction * move_speed * walk
		pick_new_state()
		
		# Move and Slide function uses velocity of character body to move character or 
		move_and_collide(velocity * delta)

# func take_damage(damage):
#	life_controller.take_damage(damage)

func die():
	var item_obj = ItemObj.instantiate()
	get_parent().add_child(item_obj)
	item_obj.global_position = global_position
	queue_free()
	
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
	update_animation_parameters()

func update_animation_parameters():
	animation_tree.set("parameters/idle/blend_position", direction.x)
	animation_tree.set("parameters/walk/blend_position", direction.x)
	animation_tree.set("parameters/attack/blend_position", direction.x)

