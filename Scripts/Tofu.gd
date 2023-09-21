extends Area2D

onready var collection_effect = preload("res://Scenes/CollectionEffect.tscn")

func _ready():
	pass

func _on_Tofu_body_entered(body):
	if body.is_in_group("players"):
		body.get_tofu(1)
		var collectionEffectInst = collection_effect.instance()
		var world = get_tree().current_scene
		world.add_child(collectionEffectInst)
		collectionEffectInst.global_position = global_position
		queue_free()
