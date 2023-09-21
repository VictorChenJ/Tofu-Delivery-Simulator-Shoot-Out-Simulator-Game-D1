extends Area2D

var velocity: Vector2 = Vector2()
var duration = 20

onready var Damaged_effects = preload("res://Scenes/DamagedEffects.tscn")

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _process(delta: float) -> void:
	position += velocity * delta
	
	duration -= delta
	if duration <= 0:
		queue_free()

func _on_body_entered(body):
	# "body" here is the thing that we've hit
	# Here we check if the body is a player, so we know to deal damage to them
	# There are other ways to do this including class names and collision layers
	if body.is_in_group("players"):
		# You need to make sure your player has a "take_damage" function
		body.take_damage(1)
		var DamagedEffectsInst = Damaged_effects.instance()
		var world = get_tree().current_scene
		world.add_child(DamagedEffectsInst)
		DamagedEffectsInst.global_position = global_position
		queue_free()
