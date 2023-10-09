extends Particles2D

func _ready():
	emitting=true
	pass
func _process(delta):
	if !emitting:
		queue_free()
