extends Node2D

export var is_dialogue_on = false

const DIALOGUE_BOX = preload("res://UI/DialogueBox/DialogueBoxTutorial.tscn")

onready var timer = $DialogueTimer
onready var ui = $CanvasLayer
onready var cactus_dbox_area = $CactusDBoxArea

func _ready():
	timer.start()
	
func _on_DialogueTimer_timeout():
	var d_box = DIALOGUE_BOX.instance()
	is_dialogue_on = true
	d_box.dialogue = ["Welcome back to your quest for manlihood, Randal Dandellion!", "What's that? You don't remember how to walk...?", "Surely you remember that you can use the WASD keys to move around!", "You can also ROLL using the LEFT-SHIFT key to move faster and get down to business.", "Your home town should be close... try heading right!"]
	ui.add_child(d_box)


func _on_CactusDBoxArea_body_entered(body):
	if is_dialogue_on == false:
		var d_box = DIALOGUE_BOX.instance()
		is_dialogue_on = true
		d_box.dialogue = ["Seems like a wall of cacti is blocking off your path...", "Press the LEFT-CLICK button on your mouse to use your knife and get through!"]
		ui.add_child(d_box)
		cactus_dbox_area.queue_free()
