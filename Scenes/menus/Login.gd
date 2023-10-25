extends Control

#var username=""
#var password=""
var checkusername="test"
var checkpassword="test"
var login=false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
#func _physics_process(delta):
#	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.




func _on_Login_button_pressed():
	if $Username.text==checkusername&&$Password.text==checkpassword:
		get_tree().change_scene("res://Scenes/menus/StartMenu.tscn")
	pass # Replace with function body.

func _on_Create_button_pressed():
	checkusername=$Username.text
	checkpassword=$Password.text
	pass # Replace with function body.
