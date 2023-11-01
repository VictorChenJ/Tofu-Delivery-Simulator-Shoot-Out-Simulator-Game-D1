extends Label

func _ready():
	var MapSettings= get_node("/root/GlobalVar")
	var time=MapSettings.time_passed/1000
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "%02d : %02d : %03d" % [mins,secs,mils]
	text = time_passed 
