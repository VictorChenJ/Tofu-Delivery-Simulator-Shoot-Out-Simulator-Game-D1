extends Control
onready var MapSettings= get_node("/root/GlobalVar")

func _ready():
	print(MapSettings.leaderboard)
	
func _on_button_press():
	get_node(".").hide()
	var children = get_node("VBoxContainer")
	print(MapSettings.leaderboard)
	for i in children.get_child_count():
		if i+1>MapSettings.leaderboard.size():
			break
		var child = children.get_child(i)
		var ptext=child.get_child(0)
		var stext=child.get_child(1)
		if MapSettings.leaderboard[i].score!=null:
			
			ptext.text=MapSettings.leaderboard[i].username
			var time =float( MapSettings.leaderboard[i].score)/1000
			var mils = fmod(time,1)*1000
			var secs = fmod(time,60)
			var mins = fmod(time, 60*60) / 60
			
			var time_passed = "%02d : %02d : %03d" % [mins,secs,mils]
			stext.text=time_passed
			continue;
		ptext.text="Player"
		stext.text="Score"
	get_node(".").show()
