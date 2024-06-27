extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Network=get_node("/root/Network")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	#Network._check_scores("scoreAkina")
	var MapSettings = get_node("/root/GlobalVar")
	MapSettings.temp={
		id=49,
		time=21,
		username="baldguy",
		map="scoreAkina"
	}
	var id = MapSettings.id
	Network._user_scores(49)
	pass # Replace with function body.
