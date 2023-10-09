extends Node2D


func _ready():
	connect("tofu_delivered", self, "_on_delivery_tofu_delivered")
	#print(get_tree().current_scene.filename)
	pass # Replace with function body.




var wincon = get_child_count()
func _on_delivery_tofu_delivered():
	if 0==wincon:
		if(get_tree().current_scene.filename=="res://Scenes/maps/Akina.tscn"):
			var MapSettings = get_node("/root/GlobalVar")
			MapSettings.AkinaPassed = true
		get_tree().change_scene("res://Scenes/menus/WinScreen.tscn")
	pass # Replace with function body.






#func _on_delivery6_tofu_delivered():
#	pass # Replace with function body.


#func _on_delivery_tofu_delivered():
#	pass # Replace with function body.
