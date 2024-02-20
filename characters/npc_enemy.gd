extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)

# parameters/idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var timer = $WalkTimer
@onready var sprite = $Sprite2D

# Combat status control
@export var max_hp : int = 3
var curr_hp = max_hp

var rng = RandomNumberGenerator.new()
var walk = 0
var direction = Vector2()

func _ready():
	var cw = func check_walk() :
		# print("Randomizing movement option")
		walk = rng.randi_range(0, 1)
		direction = Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
		pick_dir()
	
	timer.connect("timeout", cw)
	
func _physics_process(delta):
# Update velocity
	velocity = direction * move_speed * walk
	pick_new_state()
	
	# Move and Slide function uses velocity of character body to move character or 
	move_and_collide(velocity * delta)


func take_damage(damage):
	var dmg = damage
	curr_hp -= dmg
	print(curr_hp)
	if (curr_hp <= 0):
		die()

func die():
	queue_free()
	
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")

func pick_dir():
	if (direction.x < 0):
		sprite.flip_h = true
	elif (direction.x > 0):
		sprite.flip_h = false
