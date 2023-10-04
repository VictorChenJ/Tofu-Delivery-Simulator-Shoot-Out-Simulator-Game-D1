extends Node

var rng = RandomNumberGenerator.new()
var random_number

func _process(delta):
	if !$DynamicAudioPlayer.playing:
		rng.randomize()
		random_number = rng.randi_range(0, 14)
		$DynamicAudioPlayer.stream = load("res://asset/music/" + str(random_number) + ".mp3")
		$DynamicAudioPlayer.play()
