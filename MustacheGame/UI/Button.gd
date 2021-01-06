extends Button

onready var player = $AudioStreamPlayer

func _pressed():
	player.play()
