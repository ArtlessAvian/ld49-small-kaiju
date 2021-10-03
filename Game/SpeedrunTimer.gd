extends Label

var gameover = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"../../Player".first_input == 0:
		text = "00:00.000"
	elif not gameover:
		var time = OS.get_system_time_msecs() - $"../../Player".first_input
		var msec = time % 1000
		var sec = int(time / 1000) % 60
		var minutes = int(time / 60 / 1000)
		text = left_pad(minutes) + ":" + left_pad(sec) + "." + left_pad(msec, 3)

func left_pad(a, chars = 2):
	# haha remember this fiasco
	var out = str(a)
	while len(out) < chars:
		out = "0" + out
	return out

func gameover():
	gameover = true
