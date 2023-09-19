extends KinematicBody2D
 
#Enemy movement
var speed = 200
var motion = Vector2.ZERO
var player = null


#Bullet
const obj_bullet = preload("res://Scenes/bullet.tscn")
var plpos =0
var timer = 0
var time_interval = 1.0


func _physics_process(delta):
	motion = Vector2.ZERO
	if player:
		motion = position.direction_to(player.position) * speed
	motion = move_and_slide(motion)

#Bullet
func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instance()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
	new_bullet.position = position
	get_parent().add_child(new_bullet)

func _process(delta):
	timer += delta
	
	if timer >= time_interval:
		shoot(plpos, 400)
		timer = 0

func _ready():
	connect("playerposition", self, "_on_Player_playerposition")
	
func _on_Player_playerposition(val):
	plpos=rad2deg(get_angle_to(val))
	pass # Replace with function body.



func _on_Area2D_body_entered(body):
	print("enter")
	player = body
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	print("exit")
	player = null
	pass # Replace with function body.
