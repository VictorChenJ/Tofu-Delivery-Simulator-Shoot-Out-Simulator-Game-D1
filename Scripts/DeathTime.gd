extends Label

func _ready():
	var MapSettings= get_node("/root/GlobalVar")
	text = MapSettings.time_passed 
