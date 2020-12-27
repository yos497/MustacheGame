extends Control

var health = 10 setget set_health
var max_health = 10 setget set_max_health

onready var healthFull = $HealthFull

func set_health(value):
	health = clamp(value, 0, max_health)
	if healthFull != null:
		healthFull.rect_size.x = health * 6




func set_max_health(value):
	max_health = max(value, 1)

func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_health")

	
	
