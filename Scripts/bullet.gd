extends Area2D

var velocity: Vector2 = Vector2()
var duration = 20
var damage = 1

onready var Ricochet_effect = preload("res://Scenes/BulletRichochetEffect.tscn")

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _process(delta: float) -> void:
	position += velocity * delta
	
	duration -= delta
	if duration <= 0:
		queue_free()

func _on_body_entered(body):
	if !body.is_in_group("enemies"):
		if body.is_in_group("players"):
			body.take_damage(damage)
		var RichochetEffectsInst = Ricochet_effect.instance()
		var world = get_tree().current_scene
		world.add_child(RichochetEffectsInst)
		RichochetEffectsInst.global_position = global_position
		RichochetEffectsInst.rotate(rotation)
		queue_free()
