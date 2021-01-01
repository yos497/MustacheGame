extends RichTextLabel

var dialogue = ["Hey, it's me, Goku!", "Hahaha!"]
var page = 0

func _ready():
	set_bbcode(dialogue[page])
	set_visible_characters(0)

func _input(event):
	if event is InputEventMouseButton:
		if get_visible_characters() > get_total_character_count():
			if page < dialogue.size() - 1:
				page += 1
				set_bbcode(dialogue[page])
				set_visible_characters(0)

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
