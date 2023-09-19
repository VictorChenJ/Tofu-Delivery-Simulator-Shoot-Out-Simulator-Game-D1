extends KinematicBody2D
 
# I like to have these scenes start with obj_, to distinguish them from other similarly named variables
const obj_bullet = preload("res://Scenes/bullet.tscn")
 
func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instance()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
	new_bullet.position = position
	get_parent().add_child(new_bullet)

func _process(delta):
	shoot(10, 100)
