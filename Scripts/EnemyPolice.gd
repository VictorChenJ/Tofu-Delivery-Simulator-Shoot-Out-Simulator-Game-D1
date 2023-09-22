extends "res://Scripts/Enemy.gd"

func _ready():
	Ehp = 3
	attack_speed = 0.005
	speed = 100
	
func _process(delta):
	timer += attack_speed
	if player:
		_on_Player_playerposition(player.position)
		$Sprite.rotation = get_angle_to(player.position)
		if timer >= time_interval:
			shoot(plpos + 20, 400)
			shoot(plpos + 10, 400)
			shoot(plpos, 400)
			shoot(plpos - 10, 400)
			shoot(plpos - 20, 400)
			timer = 0
