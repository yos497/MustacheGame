extends RichTextLabel

var dialogue = ["Yo test test test!", "Hey, it's me, Goku! Want to see me go beyond the level of a super saiyan?", "Hahaha!"]
var page = 0

func _ready():
	set_bbcode(dialogue[page])
	set_visible_characters(0)
	set_process_input(true)

func _input(event):
	if Input.is_mouse_button_pressed(1):
		if get_visible_characters() > get_total_character_count():
			if page < dialogue.size() - 1:
				page += 1
				set_bbcode(dialogue[page])
				set_visible_characters(0)
		else:
			set_visible_characters(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
