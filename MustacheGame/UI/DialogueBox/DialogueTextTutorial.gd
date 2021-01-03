extends "res://UI/DialogueBox/DialogueText.gd"

func _input(event):
	if Input.is_mouse_button_pressed(1):
		if get_visible_characters() > get_total_character_count():
			if page < dialogue.size() - 1:
				page += 1
				cont_sound.play()
				set_bbcode(dialogue[page])
				set_visible_characters(0)
			elif close_sound_cond == true:
				get_parent().hide()
				close_timer.start()
				close_sound.play()
				close_sound_cond = false

func _on_CloseTimer_timeout():
	get_parent().get_parent().get_parent().is_dialogue_on = false
	close_sound.queue_free()
	get_parent().queue_free()
