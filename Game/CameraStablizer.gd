extends Camera

#var last_global_pos : Vector3
#const offset = Vector3(0, 0, 10)
#
#func _ready():
#	last_global_pos = global_transform.origin
#
#func _process(delta):
#	global_transform.origin = last_global_pos
#	translation = translation.linear_interpolate(offset, 0.1)
#	last_global_pos = global_transform.origin
