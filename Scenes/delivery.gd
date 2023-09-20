extends Area2D

var tofuAmount = 0

func _ready():
	connect("tofuamount", self, "_on_tofu_amount_changed")
	
func _on_tofu_amount_changed(new_tofu_amount):
	print("Tofu amount changed to:", new_tofu_amount)
	tofuAmount = new_tofu_amount
	# You can now use new_tofu_amount in your delivery logic.

func _on_delivery_body_entered(body):
	if tofuAmount >= 1:
		if body.is_in_group("players"):
			body.get_tofu((-1))
			emit_signal("tofu_delivered")
		queue_free()
	pass # Replace with function body.

