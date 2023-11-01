extends Control
var scoreboard=0

func _ready():
	$leaderboard_board.hide()

func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/menus/StartMenu.tscn")

func _on_Akina_pressed():
	scoreboard=1
	$leaderboard_board.show()
	pass # Replace with function body.

func _on_Shutoko_pressed():
	scoreboard=2
	$leaderboard_board.show()
	pass # Replace with function body.
