extends Camera2D

func _ready():
	yield(get_tree().create_timer(1.75), "timeout")
	get_tree().change_scene("res://Scenes/menus/DeathScreen.tscn")
