extends RigidBody2D

const obj_bullet = preload("res://bullet.tscn")

func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instance()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
	new_bullet.position = position
	get_parent().add_child(new_bullet)
