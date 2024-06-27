extends CanvasLayer
onready var Network=get_node("/root/Network")

var time
var username
var id

#Insert, Select, Update & Delete : setup data & SQL


#Insert, Select, Update & Delete executes

func _ready():
	var MapSettings= get_node("/root/GlobalVar")
	username=MapSettings.Username
	id=MapSettings.id
	
	if MapSettings.AkinaPassed==true:

		MapSettings.AkinaPassed=false
		time=MapSettings.AkinaTime
		
		#Network._add_score(id,username,time,"scoreAkina")
	if MapSettings.ShutokoPassed==true:

		MapSettings.ShutokoPassed=false
		time=MapSettings.ShutokoTime

		#Network._add_score(id,username,time,"scoreShutoko")

func _on_RestartButton_pressed():
	get_tree().change_scene("res://Scenes/menus/StartMenu.tscn")
