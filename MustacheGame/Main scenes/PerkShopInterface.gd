extends Control

onready var texture = $SpriteTexture
onready var first_delay = $FirstSpeechDelay
onready var after_elipses = $AfterElipses
onready var music = $BackbayLounge
onready var text_pop = $TextPop

const DIALOGUE_BOX = preload("res://UI/DialogueBox/DialogueBoxTutorial.tscn")

func _ready():
	if SceneChanger.manliness == 0:
		texture.frame = 1
		first_delay.start()

func _on_AfterElipses_timeout():
	texture.frame = 0
	music.play()
	var d_box = DIALOGUE_BOX.instance()
	SceneChanger.is_dialogue_on = true
	d_box.dialogue = ["Hello there, fancy seeing another cowboy in town", "well shoo my bro"]
	texture.frame = 2
	add_child(d_box)

func _on_FirstSpeechDelay_timeout():
	var d_box = DIALOGUE_BOX.instance()
	SceneChanger.is_dialogue_on = true
	d_box.dialogue = [".  .  .  .  ."]
	add_child(d_box)
	text_pop.play()
	d_box.get_child(0).connect("queue_free_signal", self, "on_Dialogue_queue_free")
	
func on_Dialogue_queue_free():
	after_elipses.start()
