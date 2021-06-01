extends "res://Stats.gd"

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		SceneChanger.change_scene("res://Main scenes/GameOver.tscn", 'fade')
		health = 10
