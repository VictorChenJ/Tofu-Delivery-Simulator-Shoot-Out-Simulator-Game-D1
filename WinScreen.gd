extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("tofuamount", self, "_on_Player_tofuamount")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var winvar=0


func _on_Player_tofuamount(val):
	winvar = winvar + val

	if winvar==get_child_count() && val==0:
		get_tree().quit()
