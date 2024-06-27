extends Control
onready var MapSettings= get_node("/root/GlobalVar")

#func _ready():
#	print(MapSettings.leaderboard)
	
func _on_button_press():
	get_node(".").hide()
	var children = get_node("VBoxContainer")
	#print(MapSettings.leaderboard)
	for i in children.get_child_count():
		
		var child = children.get_child(i)
		var ptext=child.get_child(0)
		var stext=child.get_child(1)
		ptext.text=" "
		stext.text=" "
		if i+1>MapSettings.leaderboard.size():
			continue
		if MapSettings.leaderboard[i].score!=null:
			
			ptext.text=MapSettings.leaderboard[i].username
			var time =float( MapSettings.leaderboard[i].score)/1000
			var mils = fmod(time,1)*1000
			var secs = fmod(time,60)
			var mins = fmod(time, 60*60) / 60
			
			var time_passed = "%02d : %02d : %03d" % [mins,secs,mils]
			stext.text=time_passed
			continue;
		
	get_node(".").show()
