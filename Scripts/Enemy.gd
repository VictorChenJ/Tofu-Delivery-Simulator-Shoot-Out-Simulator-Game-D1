extends KinematicBody2D

# Enemy health
var Ehp = 2 setget set_Ehp
signal Ehp_changed

# Enemy movement
var speed = 200
var motion = Vector2.ZERO
var player = null

# Bullet
const obj_bullet = preload("res://Scenes/bullet.tscn")
var plpos = 0
var timer = 0
var time_interval = 1.0
var attack_speed = 0.025

#death
onready var death_effect = preload("res://Scenes/DeathEffect.tscn")

# Følger efter player
func _physics_process(delta):
	motion = Vector2.ZERO
	if player:
		motion = position.direction_to(player.position) * speed
	motion = move_and_slide(motion)

# Bullet
func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instance()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
	new_bullet.position = position
	get_parent().add_child(new_bullet)
	new_bullet.rotate(deg2rad(direction))
	$GunshotSoundPlayer.play()

func _process(delta):
	timer += attack_speed
	
	if player:
		_on_Player_playerposition(player.position)
		if timer >= time_interval:
			shoot(plpos, 400)
			timer = 0

func _on_Player_playerposition(val):
	plpos = rad2deg(get_angle_to(val))
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.is_in_group("players"):
		print("enter")
		player = body
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.is_in_group("players") and body == player:
		print("exit")
		player = null
	pass # Replace with function body.

# Enemy health
func take_damage(dmg):
	set_Ehp(Ehp - dmg)

func set_Ehp(new_Ehp):
	emit_signal("Ehp_changed", new_Ehp)
	Ehp = new_Ehp
	if Ehp <= 0:
		die()

func die():
	emit_signal("e_died")
	var deathEffectInst = death_effect.instance()
	var world = get_tree().current_scene
	world.add_child(deathEffectInst)
	deathEffectInst.global_position = global_position
	queue_free()
	
