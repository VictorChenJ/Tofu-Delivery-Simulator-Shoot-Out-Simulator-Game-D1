extends KinematicBody2D

var dead = false

#drifting particles
onready var driftingparticlesleft=$Driftingparticlesleft
onready var driftingparticlesright=$Driftingparticlesright
var driftingParticleDirection=0
#Tile speed
var tileSpeedModifiers = {
	0: 1.0,  
	1: 1.0,  
	2: 1.0,   
	3: 1.0,   
	4: 0.97,
	7: 1.0,
}

#Hp related

var hp = 15 setget set_hp

signal hp_changed
signal died
signal playerposition
signal tofu_delivered

#tofu
var tofu = 0 setget set_tofu

#PlayerBullet
const obj_PlayerBullet = preload("res://Scenes/misc/PlayerBullet.tscn")
var mouse_position = null
var timer = 0
var time_interval = 5.0
var timer_speed = 0.256

var wheel_base = 200  # Distance from front to rear wheel
var steering_angle = 5  # Amount that front wheel turns, in degrees

var velocity = Vector2.ZERO
var steer_angle

var originalEnginePower = 800
var engine_power = originalEnginePower  # Forward acceleration force.

var acceleration = Vector2.ZERO

var friction = -0.9
var drag = -0.0015
var originalBreakingPower = -450
var braking_power = originalBreakingPower
var max_speed_reverse = 250

var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction

var drivingStartupSound = true # Determines wether the car plays the driving startup sound or not

var accelerating = false
var braking = false
var drifting = false

var shootIndex = 0
var trueAmmo = 6 # The ammo it returns to when removing weapons
var ammo = 6
var bulletSpeed = 1200

var shotgun = false
var shotgunBulletLayers = 2
var bulletSpread = 5
var bulletSpreadIncrease = bulletSpread # Increases bullet spread the more shots are fire at the same time

var burst = false
var burstShots = 3
var burstDelay = 0.1
var bursting = false # Is the player shooting with burst currently?

onready var death_effect = preload("res://Scenes/effects/PlayerDeathEffect.tscn")

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	update_health()
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
	
	var tile_position = get_parent().get_node("MainMap").world_to_map(position)
	var tile_id = get_parent().get_node("MainMap").get_cellv(tile_position)
	
	if tileSpeedModifiers.has(tile_id):
		velocity *= tileSpeedModifiers[tile_id]

func get_input():
	if dead == false:
		var turn = 0
		if Input.is_action_pressed("steer_right"):
			driftingParticleDirection=0
			turn += 1
		if Input.is_action_pressed("steer_left"):
			driftingParticleDirection=1
			turn -= 1
		steer_angle = turn * steering_angle
		if Input.is_action_pressed("godmode"):
			hp = 10000;
		if Input.is_action_pressed("accelerate"):
			if(!drifting):
				acceleration = transform.x * engine_power
			else:
				acceleration = transform.x * engine_power * 0.35
			if(!braking):
				play_driving_sounds()
				accelerating = true
		elif(!braking):
			stop_driving_sounds()
			accelerating = false
		if Input.is_action_pressed("brake"):
			acceleration = transform.x * braking_power
			if(!accelerating):
				play_driving_sounds()
				braking = true
		elif(!accelerating):
			stop_driving_sounds()
			braking = false
		if Input.is_action_just_pressed("left_click"):
			mouse_position = rad2deg(get_angle_to(get_global_mouse_position())+rotation)
			if shotgun:
				bulletSpreadIncrease = bulletSpread
				for n in shotgunBulletLayers:
					shoot(mouse_position + bulletSpreadIncrease, bulletSpeed)
					shoot(mouse_position - bulletSpreadIncrease, bulletSpeed)
					bulletSpreadIncrease += bulletSpread
			if burst:
				if !bursting:
					for n in burstShots:
						bursting = true
						shoot(mouse_position, bulletSpeed)
						yield(get_tree().create_timer(burstDelay), "timeout")
					bursting = false
			if !burst:
				shoot(mouse_position, bulletSpeed)

		if (Input.is_action_pressed("reload") && !$ReloadSoundPlayer.playing):
			shootIndex = 0
			$ReloadSoundPlayer.play()
		if (Input.is_action_pressed("handbrake") && velocity.x != 0):
			drifting = true
			if(!$DriftSoundPlayer.playing):
				$DriftSoundPlayer.play()
		else:
			drifting = false
			$DriftSoundPlayer.stop()

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	var new_heading
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	if (drifting == true):
		driftingparticleeffect()
		rear_wheel += velocity.rotated(steer_angle) * delta
		front_wheel -= velocity.rotated(steer_angle) * delta
		new_heading = (front_wheel - rear_wheel).normalized()
	else:
		driftingparticlesleft.emit=0
		driftingparticlesright.emit=0
		rear_wheel -= velocity * delta
		front_wheel -= velocity.rotated(steer_angle) * delta
		new_heading = (front_wheel - rear_wheel).normalized()
		var d = new_heading.dot(velocity.normalized())
		if d > 0:
			velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
		if d < 0:
			velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func _on_Crash_body_entered(body):
	if (!body.is_in_group("players")):
		if (velocity.x > 150 || velocity.x < -150 || velocity.y > 150 || velocity.y < -150):
			take_damage(1)
			$CollisionSoundPlayer.play()
	if body.is_in_group("enemies"):
		body.take_damage(1)
		print("Collided with: " + str(body))

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

func set_hp(new_hp):
	if new_hp > 15:
		new_hp = 15
	emit_signal("hp_changed", new_hp)
	hp = new_hp
	if hp <= 0:
		die()

func die():
	emit_signal("died")
	dead = true
	var deathEffectInst = death_effect.instance()
	var world = get_tree().current_scene
	world.add_child(deathEffectInst)
	deathEffectInst.global_position = global_position
	queue_free()

	
func _process(delta):
	emit_signal("playerposition", position)

func update_health():
	var healthbar = $HealthBar
	healthbar.value = hp
	
	if hp >= 15:
		healthbar.visible = false
	else:
		healthbar.visible = true

#tofu stuff
func set_tofu(value):
	tofu += value
	print(tofu)

#PlayerBullet
func shoot(direction: float, speed: float):
	if dead == false:
		if (shootIndex < ammo && !$ReloadSoundPlayer.playing):
			var new_PlayerBullet = obj_PlayerBullet.instance()
			shootIndex += 1
			new_PlayerBullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
			new_PlayerBullet.position = position
			get_parent().add_child(new_PlayerBullet)
			new_PlayerBullet.rotate(deg2rad(direction))
			$GunShotSoundPlayer.play()
		elif (!$ReloadSoundPlayer.playing):
			$ReloadSoundPlayer.play()
			shootIndex = 0

func removeWeapons():
	shotgun = false
	burst = false
	ammo = trueAmmo
	
func driftingparticleeffect():
	if (driftingParticleDirection==0):
		driftingparticlesleft.emit=1
		driftingparticlesright.emit=0
	else:
		driftingparticlesright.emit=1
		driftingparticlesleft.emit=0
