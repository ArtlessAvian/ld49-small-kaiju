extends Spatial

var gameover = false
var old_transform = Transform()

func _process(delta):
#	hardcoded
	if gameover:
		if $"../Visuals/Sprite3D".visible:
			var old_translation = translation
			var old_scale = scale
			global_transform = Transform() # can't figure out how to unrotate in time
			translation = old_translation * (1 - pow(1-0.9, delta*144))
			scale = old_scale
			global_rotate(Vector3.RIGHT, -30 * PI/180)
			old_transform = global_transform
		else:
			global_transform = old_transform

func _on_Thing_attacked():
	if not gameover:
		gameover = true
		$Camera.current = true
		get_tree().root.propagate_call("gameover")

		var player = $"../../../Player/Offset"
		self.global_transform = player.global_transform
