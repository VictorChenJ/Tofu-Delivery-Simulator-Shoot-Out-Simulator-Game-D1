extends Label

func _on_Player_ammo_changed(new_ammo):
	text = "Ammo: " + str(new_ammo)
