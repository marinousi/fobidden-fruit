extends KinematicBody2D

var speed = 80  # speed in pixels/sec

#onready AnimationPlayer = $AnimationPlayer
var velocity = Vector2.ZERO
var movement = Vector2(0,0)

var ataque = false

enum {
	MOVE,
	ATTACK
	
}

var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var Anim_position = 1

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		
		
func move_state(delta):
	
	var axis_speed = Vector2.ZERO
	axis_speed.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	axis_speed.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	axis_speed = axis_speed.normalized()
	
	if axis_speed != Vector2.ZERO:
		animationTree.set("parameters/Stando/blend_position", axis_speed)
		animationTree.set("parameters/Run/blend_position", axis_speed)
		animationTree.set("parameters/Bate/blend_position", axis_speed)
		animationState.travel("Run")
	else:
		animationState.travel("Stando")
		
	move_and_slide(axis_speed * speed)
	
	if Input.is_action_just_pressed("hit"):
		state = ATTACK
	
	
func attack_state(delta):
	animationState.travel("Bate")

	
func Final_Ataque():
	state = MOVE
	
