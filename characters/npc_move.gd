extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)

# parameters/idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var timer = $WalkTimer

var rng = RandomNumberGenerator.new()
var walk = 0
var direction = Vector2()

func _ready():
	var cw = func check_walk() :
		print("Randomizing movement option")
		walk = rng.randi_range(0, 1)
		direction = Vector2(rng.randi_range(-1, 1), rng.randi_range(-1, 1))
	
	timer.connect("timeout", cw)
	
func _physics_process(_delta):
# Update velocity
	velocity = direction * move_speed * walk
	pick_new_state()
	
	# Move and Slide function uses velocity of character body to move character or 
	move_and_slide()

func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
