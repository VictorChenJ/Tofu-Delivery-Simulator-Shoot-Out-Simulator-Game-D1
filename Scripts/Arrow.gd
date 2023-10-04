extends Sprite
bool onscreen(true)
var projectResolution=Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))
func isOnScreen(target):
		if(target.top > 0 && target.top < screen.height && target.left < screen.width && target.left > 0):
		{return true;}
	else{

		//the target is off-screen, find indicator position.

		return false;

	}

}

	pass

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
