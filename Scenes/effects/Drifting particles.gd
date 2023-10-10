extends Node2D
onready var sparks=$Sparks
onready var drift=$Drift
var emit=0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func emitter():
	if (emit>0):
		drift.emitting=true
		sparks.emitting=true
	else:
		drift.emitting=false
		sparks.emitting=false
func _process(delta):
	emitter()
	print(emit)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
