extends Control

func _ready():
	connect("hp_changed", self, "_on_hp_changed")

func _on_hp_changed(new_hp):
	var progress_bar = $HealthBar  # Replace with your actual progress bar path
	progress_bar.value = new_hp
	print("hej")
