extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	var MapSettings= get_node("/root/GlobalVar")
	var button = get_node("CenterContainer/VBoxContainer/ShutokoLevel")
	button.disabled = true
	if(MapSettings.OAkinaPassed==true):
		button.disabled=false
	pass # Replace with function body.



func _on_AkinaLevel_pressed():
	get_tree().change_scene("res://Scenes/maps/Akina.tscn")
	pass # Replace with function body.


func _on_ShutokoLevel_pressed():
	get_tree().change_scene("res://Scenes/maps/Shutoko.tscn")
	pass # Replace with function body.
