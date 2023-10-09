extends Light2D

var state = 0
var transitionDuration = 0.5
var transitionTimer = 0.5

func _ready():
	pass

func _process(delta):
	transitionTimer += delta
	
	if transitionTimer >= transitionDuration:
		transitionTimer = 0.0
		state = 1 - state
	
	if state == 1:
		show()
	else:
		hide()
