extends Node2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const TutCactusKnock = preload("res://Effects/TutCactusKnock.tscn")

onready var stats = $Stats
onready var animationPlayer = $AnimationPlayer

func _on_Hurtbox_area_entered(area):
	animationPlayer.play("Knocked")
	stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_AnimationPlayer_animation_finished(Knocked):
	animationPlayer.play("Idle")
