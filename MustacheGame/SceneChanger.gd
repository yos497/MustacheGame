extends CanvasLayer

onready var animation = $AnimationPlayer
var scene : String
export var is_perkshop_first_visit = true

func change_scene(new_scene, anim):
	scene = new_scene
	animation.play(anim)
	
func _new_scene():
	get_tree().change_scene(scene)
