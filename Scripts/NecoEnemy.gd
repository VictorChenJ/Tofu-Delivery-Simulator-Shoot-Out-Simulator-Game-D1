extends "res://Scripts/Enemy.gd"

func _ready():
	Ehp = 25
	attack_speed = 50

func _process(delta):
	rotate(1.5)
