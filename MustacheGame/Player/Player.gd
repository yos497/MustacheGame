extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 110
export var FRICTION = 500

const BULLET = preload("res://Bullet.tscn")

enum {
	MOVE,
	ROLL,
	SLASH,
	SHOOT_BOW
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var rolling = false

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var knifeHitbox = $HitboxPoint/KnifeHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimation = $BlinkAnimation
onready var timer = $Timer
onready var groan = $PlayerGroan

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	knifeHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
			
		SLASH:
			slash_state(delta)
			
		SHOOT_BOW:
			shoot_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	var mouse_position = Vector2.ZERO
	mouse_position.x = get_global_mouse_position().x - self.get_global_position().x
	mouse_position.y = get_global_mouse_position().y - self.get_global_position().y
	
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		knifeHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Slash/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/ShootBow/blend_position", mouse_position)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationTree.set("parameters/ShootBow/blend_position", mouse_position)
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		rolling = true
		hurtbox.start_invincibility(0.5)
	
	if Input.is_action_just_pressed("attack") and get_parent().get_parent().is_dialogue_on == false:
		state = SLASH
		
	if Input.is_action_just_pressed("shoot"):
		state = SHOOT_BOW
	
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func slash_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Slash")

func shoot_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("ShootBow")


func move():
	move_and_slide(velocity)

func roll_animation_finished():
	state = MOVE
	rolling = false

func slash_animation_finished():
	state = MOVE
	
func shoot_animation_finished():
	state = MOVE
	
func shoot():
	var bullet = BULLET.instance()
	var posit = self.get_global_position()
	var angle = get_angle_to(get_global_mouse_position()) + self.get_rotation()
	posit.y = posit.y - 5
	
	get_parent().add_child(bullet)
	bullet.set_position(posit)
	bullet.set_angle(angle)
	

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	groan.play()
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()


func _on_Hurtbox_invincibility_started():
	if rolling == false:
		blinkAnimation.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimation.play("Stop")
