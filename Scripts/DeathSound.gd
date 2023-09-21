extends AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	pass # Replace with function body.
	
func _process(delta):
	if(!playing):
		queue_free()
