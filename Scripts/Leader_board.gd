extends Control
var scoreboard=0

func _physics_process(delta):
	if(scoreboard==0):
		$leaderboard_board.hide()

func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/menus/MapSelection.tscn")

func _on_Akina_pressed():
	scoreboard=1
	$leaderboard_board.show()

func _on_Shutoko_pressed():
	scoreboard=2
	$leaderboard_board.show()

