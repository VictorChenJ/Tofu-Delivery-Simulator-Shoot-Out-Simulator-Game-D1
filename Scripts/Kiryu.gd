extends "res://Scripts/Enemy.gd"

func _ready():
	Ehp = 50
	attack_speed = 0.01
	speed = 300
	
func _process(delta):
	timer += attack_speed
