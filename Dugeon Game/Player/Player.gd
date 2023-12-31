extends KinematicBody2D

export var MAX_SPEED = 100
export var ACCELERATION = 400
export var FRICTION = 600
export var ROLL_SPEED = 125

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector


func _physics_process(delta):
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)



func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x =Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y =Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED )
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func move():
	velocity = move_and_slide(velocity)


func roll_animation_finished():
	state = MOVE


func attack_animation_finished():
	state = MOVE

# Shooting
#const BULLET = preload("res://World/Pfeil.tscn")
#const  global = 10

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == BUTTON_LEFT and event.pressed:
			#if (event.position != position):
				#var direction = (get_global_mouse_position()- global_position).normalized()
				#var bullet = BULLET.instance()
				#get_parent().add_child(bullet)
				#bullet.global_position = global_position 
				#bullet.set_bullet_direction(direction)
