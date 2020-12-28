extends KinematicBody2D

const SPEED = 200

var velocity = Vector2.ZERO
var direction

onready var bulletHitbox = $BulletHitbox

func _ready():
	pass

func _physics_process(delta):
	position += transform.x * SPEED * delta
	velocity = move_and_slide(velocity)



	
func set_angle(angle):
	self.set_rotation(angle)
	
func set_position(position):
	global_position = position
	

func _on_Hitbox_area_entered(area):
	queue_free()
