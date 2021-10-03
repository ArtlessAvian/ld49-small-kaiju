extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	$"../CameraCast".add_exception($"../CollisionShape")

func _process(delta):
	var target_angle = -30 * PI/180
	if $"../CameraCast".is_colliding():
		target_angle = -45 * PI/180
	rotation.x = lerp(rotation.x, target_angle, 1-pow(1-0.2, delta*60))
