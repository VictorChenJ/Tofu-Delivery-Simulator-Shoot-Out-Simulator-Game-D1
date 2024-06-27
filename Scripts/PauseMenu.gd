extends CanvasLayer

onready var Network=get_node("/root/Network")
func _ready():
	var MapSettings= get_node("/root/GlobalVar")
	Network._user_scores(MapSettings.id)
func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/menus/MapSelection.tscn")


