extends Area2D
 
 
var velocity: Vector2 = Vector2()
var duration = 20
 
onready var richochet_effect = preload("res://Scenes/effects/BulletRichochetEffect.tscn")
 
func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
 
func _process(delta: float) -> void:
	position += velocity * delta
	
	duration -= delta
	if duration <= 0:
		queue_free()
 
 
 
func _on_body_entered(body):
	if !body.is_in_group("players"):
		if body.is_in_group("enemies"):
			body.take_damage(1)
		var richochetEffectInst = richochet_effect.instance()
		var world = get_tree().current_scene
		world.add_child(richochetEffectInst)
		richochetEffectInst.global_position = global_position
		richochetEffectInst.rotate(rotation)
		queue_free()
