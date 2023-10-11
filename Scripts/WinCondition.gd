extends Node2D
var wincon 

func _ready():
	connect("tofu_delivered", self, "_on_delivery_tofu_delivered")
	#print(get_child_count())
	wincon = get_child_count()
	#print(get_tree().current_scene.filename)





var winvar = 0
func _on_delivery_tofu_delivered():
	winvar = winvar +1
	print("wincon:")
	print(wincon)
	print("winvar:")
	print(winvar)
	if winvar==wincon:
		if(get_tree().current_scene.filename=="res://Scenes/maps/Akina.tscn"):
			var MapSettings = get_node("/root/GlobalVar")
			MapSettings.AkinaPassed = true
		get_tree().change_scene("res://Scenes/menus/WinScreen.tscn")
