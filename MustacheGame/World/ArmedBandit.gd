extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const BULLET = preload("res://World/EnemyBullet.tscn")

export var ACCELERATION = 200
export var MAX_SPEED = 30
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	RUN,
	SHOOT
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var shooting = false
var state = RUN

onready var sprite = $Sprite
onready var stats = $Stats
onready var playerDetection = $PlayerDetection
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var blinkAnimation = $BlinkAnimation
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var canShoot = $CanShoot
onready var animationState = animationTree.get("parameters/playback")
onready var timer = $Timer

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 400 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_timer(rand_range(1, 3))
				
			
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_timer(rand_range(1, 3))
				
			
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
			if global_position.distance_to(wanderController.target_position) <= 10:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_timer(rand_range(1, 3))
			
		RUN:
			var player = canShoot.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				direction.x = - direction.x
				direction.y = - direction.y
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
				
		SHOOT:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			animationState.travel("Shoot")
			if shooting == false:
				shoot()
				shooting = true
				timer.start()
			state = IDLE
			
			
			
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 300
		
	if velocity != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", velocity.x)
		animationTree.set("parameters/Run/blend_position", velocity.x)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
		
	
	velocity = move_and_slide(velocity)
	
	
func shoot():
	var bullet = BULLET.instance()
	var player = canShoot.player
	var posit = self.get_global_position()
	var angle = get_angle_to(player.global_position) + self.get_rotation()
	posit.y = posit.y - 5
	
	get_parent().add_child(bullet)
	bullet.set_position(posit)
	bullet.set_angle(angle)
	
	state = IDLE



func seek_player():
	if canShoot.can_see_player():
		state = SHOOT
	if playerDetection.can_see_player():
		state = RUN
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	print(stats.health)
	if area.isBullet == false:
		knockback = area.knockback_vector * 150
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.3)

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
	blinkAnimation.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimation.play("Stop")


func _on_Timer_timeout():
	shooting = false
