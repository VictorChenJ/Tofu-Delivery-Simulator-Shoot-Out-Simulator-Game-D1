extends Node

var rng = RandomNumberGenerator.new()
var random_number
var last_number

func _process(delta):
	if !$DynamicAudioPlayer.playing:
		rng.randomize()
		random_number = rng.randi_range(0, 14)
		if(random_number != last_number):
			$DynamicAudioPlayer.stream = load("res://asset/music/" + str(random_number) + ".mp3")
			$DynamicAudioPlayer.play()
			last_number = random_number
