extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)

# parameters/idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
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
	pick_new_state()
	
	# Move and Slide function uses velocity of character body to move character or
	move_and_collide(velocity * delta)

func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO) :
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
		
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
