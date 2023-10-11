extends "res://Scripts/Enemy.gd"

func _ready():
	Ehp = 50
	attack_speed = 10
	speed = 150
	
func _process(delta):
	timer += attack_speed
