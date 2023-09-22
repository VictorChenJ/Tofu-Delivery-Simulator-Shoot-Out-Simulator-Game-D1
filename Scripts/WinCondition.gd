extends Node2D


func _ready():
	connect("tofu_delivered", self, "_on_delivery2_tofu_delivered")
	pass # Replace with function body.




var winvar= 0

func _on_delivery2_tofu_delivered():
	winvar = winvar + 1
	#print("sssssssssss")
	if winvar==get_child_count():
		get_tree().change_scene("res://Scenes/WinScreen.tscn")
	pass # Replace with function body.

