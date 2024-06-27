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
	if winvar==wincon:
		var MapSettings = get_node("/root/GlobalVar")
		print(MapSettings.time_passed)
		if(get_tree().current_scene.filename=="res://Scenes/maps/Akina.tscn"):
			
			#if MapSettings.AkinaTime > MapSettings.time_passed||MapSettings.AkinaTime==0:
			#	MapSettings.AkinaTime = MapSettings.time_passed
			MapSettings.temp={
				time=MapSettings.time_passed,
				map="scoreAkina",
				username=MapSettings.username,
				id=MapSettings.id
			}
			Network._user_scores(MapSettings.id)
			MapSettings.AkinaPassed=true
			MapSettings.OAkinaPassed=true

		if(get_tree().current_scene.filename=="res://Scenes/maps/Shutoko.tscn"):
			
			#if MapSettings.ShutokoTime > MapSettings.time_passed||MapSettings.ShutokoTime==0:
			#	MapSettings.ShutokoTime = MapSettings.time_passed
			MapSettings.temp={
				time=MapSettings.time_passed,
				map="scoreShutoko",
				username=MapSettings.username,
				id=MapSettings.id
			}
			MapSettings.ShutokoPassed=true
		get_tree().change_scene("res://Scenes/menus/WinScreen.tscn")
		
