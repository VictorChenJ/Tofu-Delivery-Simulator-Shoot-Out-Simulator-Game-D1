extends Control
var scoreboard=0
signal buttonpressed

onready var Network=get_node("/root/Network")
onready var MapSettings= get_node("/root/GlobalVar")
onready var map=""

func _ready():
	$leaderboard_board.hide()
	Network.connect("LBFetch", self, "handlelb")
func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/menus/MapSelection.tscn")

func handlelb():
	var data = MapSettings.lbfetch
	var return_data={}
	var count=0
	
	for d in data:
		var newdata={"username": d.username, "score": d[map]}
		return_data[count]=newdata
		count+=1
	
	MapSettings.leaderboard = return_data
	emit_signal("buttonpressed")
func _on_Akina_pressed():
	scoreboard=1
	map="scoreAkina"
	Network._check_scores("scoreAkina")

	#$leaderboard_board.show()

func _on_Shutoko_pressed():
	map="scoreShutoko"
	Network._check_scores("scoreShutoko")
	scoreboard=2

	
	#$leaderboard_board.show()
