extends Area2D

signal tofu_delivered

onready var delivery_effect = preload("res://Scenes/DeliveryEffect.tscn")

<<<<<<< Updated upstream
func _ready():
	connect("tofuamount", self, "_on_tofu_amount_changed")
	connect("body_entered", self, "_on_body_entered")
func _on_Player_tofuamount(new_tofu_amount):
	print("Tofu amount changed to:", new_tofu_amount)
	tofuAmount = new_tofu_amount
	

func _on_body_entered(body):
	if tofuAmount >= 1:
		if body.is_in_group("players"):
			body.get_tofu((-1))
			if body.hp < 10:
				body.take_damage((10-body.hp))
=======
func _on_delivery_body_entered(body):
	if body.is_in_group("players"):
		if(body.tofu > 0):
			body.set_tofu(-1)
			body.take_damage(-5)
>>>>>>> Stashed changes
			emit_signal("tofu_delivered")
			print("tofu_delivered")
			var deliveryEffectInst = delivery_effect.instance()
			var world = get_tree().current_scene
			world.add_child(deliveryEffectInst)
			deliveryEffectInst.global_position = global_position
			print(body.hp)
			queue_free()
