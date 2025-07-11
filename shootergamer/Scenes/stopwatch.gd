extends Node2D
class_name Stopwatch

var time = 0.0
var stopped = false

func _process(delta):
	if stopped:
		return
	time += delta
	
func time_to_string() -> String:
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = time/60
	var format_string = "%02d : %02d : %02d"
	var actual_string = format_string % [min, sec, msec]
	return actual_string
	
