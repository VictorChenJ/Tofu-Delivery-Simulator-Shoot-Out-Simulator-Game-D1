extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	connect("hp_changed", self, "hpamount")
	pass # Replace with function body.
func _draw():
	pass
func hpamount(hp):
	#print("cheeese " + hp)
	get_node("/root/MarginContainer/NinePatchRect/label").text=hp
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
