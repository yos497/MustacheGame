extends CanvasLayer

onready var animation = $AnimationPlayer
var scene : String

func change_scene(new_scene, anim):
	scene = new_scene
	animation.play(anim)
	
func _new_scene():
	get_tree().change_scene(scene)
