extends Node2D


func _ready():
	connect("tofuamount", self, "_on_Player_tofuamount")
	pass # Replace with function body.




var winvar= 0

func _on_Player_tofuamount(val):
	winvar = winvar + val
	#print("sssssssssss")
	if winvar==get_child_count()&&val==0:
		get_tree().change_scene("res://Scenes/WinScreen.tscn")
	pass # Replace with function body.
