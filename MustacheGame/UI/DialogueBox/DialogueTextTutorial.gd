extends RichTextLabel

onready var close_sound = $CloseSound
onready var close_timer = $CloseTimer
onready var cont_sound = $ContinueSound
onready var dialogue = get_parent().dialogue

var close_sound_cond = true #Used as in the if statement as a means of preventing close sound from repeating
var page = 0

signal queue_free_signal

func _ready():
	set_bbcode(dialogue[page])
	set_visible_characters(0)
	set_process_input(true)

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
				emit_signal("queue_free_signal")
				close_timer.start()
				close_sound.play()
				close_sound_cond = false

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)

func _on_CloseTimer_timeout():
	SceneChanger.is_dialogue_on = false
	close_sound.queue_free()
	get_parent().queue_free()
