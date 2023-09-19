extends KinematicBody2D

#Hp related
var hp = 5 setget set_hp

signal hp_changed
signal died
signal playerposition

#PlayerBullet
const obj_bullet = preload("res://Scenes/PlayerBullet.tscn")
var mouse_position = null
var timer = 0
var time_interval = 1.0


var wheel_base = 100  # Distance from front to rear wheel
var steering_angle = 5  # Amount that front wheel turns, in degrees

var velocity = Vector2.ZERO
var steer_angle

var engine_power = 800  # Forward acceleration force.

var acceleration = Vector2.ZERO

var friction = -0.9
var drag = -0.0015
var braking_power = -450
var max_speed_reverse = 250

var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction

var drivingStartupSound = true # Determines wether the car plays the driving startup sound or not

var accelerating = false
var braking = false

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	steer_angle = turn * steering_angle
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
		print(hp)
		play_driving_sounds()
		accelerating = true
	elif(!braking):
		stop_driving_sounds()
		accelerating = false
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking_power
		play_driving_sounds()
		braking = true
	elif(!accelerating):
		stop_driving_sounds()
		braking = false
	if Input.is_action_just_pressed("left_click"):
		mouse_position = rad2deg(get_angle_to(get_global_mouse_position())+rotation)
		shoot(mouse_position,600)

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func play_driving_sounds():
	if(!$DrivingStartupPlayer.playing && drivingStartupSound):
		$DrivingStartupPlayer.play()
		drivingStartupSound = false
	if(!$DrivingSoundPlayer.playing && !$DrivingStartupPlayer.playing):
		$DrivingSoundPlayer.play()
		
func stop_driving_sounds():
	$DrivingSoundPlayer.stop()
	if(drivingStartupSound == false):
		if(!$DrivingStartupPlayer.playing):
			$DrivingShutdownPlayer.play()
			drivingStartupSound = true

#hp stuff
func take_damage ( dmg ):
	set_hp(hp - dmg)

func set_hp( new_hp ):
	emit_signal("hp_changed", new_hp)
	hp = new_hp
	if hp <= 0:
		die()
		
func die():
	emit_signal("died")
	queue_free()
	
func _process(delta):
	emit_signal("playerposition", position)

#PlayerBullet
func shoot(direction: float, speed: float):
	var new_bullet = obj_bullet.instance()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
	new_bullet.position = position
	get_parent().add_child(new_bullet)
	$GunShotSoundPlayer.play()
	
