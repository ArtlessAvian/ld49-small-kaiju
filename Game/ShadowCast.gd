extends RayCast

export var exception : NodePath

func _ready():
	if exception:
		add_exception(get_node(exception))

func _process(delta):
	if is_colliding():
		$Sprite3D.global_transform.origin.y = get_collision_point().y + 0.01
		$Sprite3D.opacity = min(1, -1 / $Sprite3D.translation.y)
	else:
		$Sprite3D.translation.y = -10000
		
