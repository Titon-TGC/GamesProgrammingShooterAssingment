extends Node

func play_sound_at_position(stream: AudioStream, position: Vector2, parent: Node) -> void:
	var audio = AudioStreamPlayer2D.new()
	audio.stream = stream
	audio.global_position = position
	parent.add_child(audio)
	audio.play()
	
	var timer = Timer.new()
	timer.wait_time = stream.get_length()
	timer.one_shot = true
	timer.timeout.connect(audio.queue_free)
	audio.add_child(timer)
	timer.start()
