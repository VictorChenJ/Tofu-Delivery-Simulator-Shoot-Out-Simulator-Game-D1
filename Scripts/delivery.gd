extends Area2D

signal tofu_delivered

onready var delivery_effect = preload("res://Scenes/effects/DeliveryEffect.tscn")

func _on_delivery_body_entered(body):
	if body.is_in_group("players"):
		if(body.tofu > 0):
			body.set_tofu(-1)
			body.take_damage(-20)
			emit_signal("tofu_delivered")
			#print("tofu_delivered")
			var deliveryEffectInst = delivery_effect.instance()
			var world = get_tree().current_scene
			world.add_child(deliveryEffectInst)
			deliveryEffectInst.global_position = global_position
			#(body.hp)
			queue_free()
