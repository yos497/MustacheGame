extends KinematicBody2D

export var SPEED = 900

var velocity = Vector2.ZERO
var direction

onready var bulletHitbox = $BulletHitbox

func _ready():
	pass

func _physics_process(delta):
	position += transform.x * SPEED * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()



	
func set_angle(angle):
	self.set_rotation(angle)
	
func set_position(position):
	global_position = position
	

func _on_Hitbox_area_entered(area):
	queue_free()
