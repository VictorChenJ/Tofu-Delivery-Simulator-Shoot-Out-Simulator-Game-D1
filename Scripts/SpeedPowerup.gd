extends Area2D

onready var collection_effect = preload("res://Scenes/effects/CollectionEffect.tscn")

func _on_SpeedPowerup_body_entered(body):
	if body.is_in_group("players"):
		body.engine_power += body.originalEnginePower/25
		body.braking_power += body.originalBreakingPower/25
		var collectionEffectInst = collection_effect.instance()
		var world = get_tree().current_scene
		world.add_child(collectionEffectInst)
		collectionEffectInst.global_position = global_position
		queue_free()
