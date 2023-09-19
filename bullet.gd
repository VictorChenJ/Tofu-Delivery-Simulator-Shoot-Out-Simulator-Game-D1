extends Area2D

var velocity: Vector2 = Vector2()
var duration = 20

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _process(delta: float) -> void:
	position += velocity * delta
	duration -= delta
	if duration <= 0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	# 'body' er tingen som bullet rammer
	if body.is_in_group("players"):
		if body.has.method("take_damage"):
			body.take_damage(1)
		queue_free()
