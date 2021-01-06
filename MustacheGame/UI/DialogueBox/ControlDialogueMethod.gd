export var is_dialogue_on = false

const DIALOGUE_BOX = preload("res://UI/DialogueBox/DialogueBox.tscn")

onready var timer = $DialogueTimer
onready var ui = $CanvasLayer
onready var cactus_dbox_area = $CactusDBoxArea

func _ready():
	timer.start()
	
func _on_DialogueTimer_timeout():
	var d_box = DIALOGUE_BOX.instance()
	is_dialogue_on = true
	d_box.dialogue = []
	ui.add_child(d_box)

func _on_CactusDBoxArea_body_entered(body):
	if is_dialogue_on == false:
		var d_box = DIALOGUE_BOX.instance()
		is_dialogue_on = true
		d_box.dialogue = ["Seems like a wall of cacti is blocking off your path...", "Press the LEFT-CLICK button on your mouse to use your knife and get through!"]
		ui.add_child(d_box)
		cactus_dbox_area.queue_free()
