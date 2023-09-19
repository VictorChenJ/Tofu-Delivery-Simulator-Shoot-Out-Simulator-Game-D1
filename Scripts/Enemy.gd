extends KinematicBody2D
 
# I like to have these scenes start with obj_, to distinguish them from other similarly named variables

const obj_bullet = preload("res://Scenes/bullet.tscn")
var plpos =0
var timer = 0
var time_interval = 5.0

func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instance()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
	new_bullet.position = position
	get_parent().add_child(new_bullet)

func _process(delta):
	timer += delta
	
	if timer >= time_interval:
		shoot(plpos, 100)
		timer = 0

func _ready():
	connect("playerposition", self, "_on_Player_playerposition")
	
func _on_Player_playerposition(val):
	plpos=rad2deg(get_angle_to(val))

	pass # Replace with function body.
