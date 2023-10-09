extends AudioStreamPlayer2D

func _ready():
	play()
	
func _process(delta):
	if(!playing):
		queue_free()
