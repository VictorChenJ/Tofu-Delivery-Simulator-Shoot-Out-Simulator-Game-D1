extends Label

func _on_KinematicBody2D_ammo_changed(new_ammo):
	text = "Ammo: " + str(new_ammo)
