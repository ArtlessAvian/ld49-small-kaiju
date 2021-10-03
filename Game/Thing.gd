extends RigidBody
signal attacked

var raycast_len = 1000000000
var queue_die_on_impact = false

export var tier = 0
var snapped = false

func _ready():
	mode = MODE_STATIC

func _physics_process(delta):
	if !snapped:
		snapped = true
		call_deferred("snap_floor")

func snap_floor():
	if $CollisionShape/SnapToFloor.is_colliding():
		var point = $CollisionShape/SnapToFloor.get_collision_point()
		var bottom = $CollisionShape/GetBottom.get_collision_point()
		translation += point - bottom
	else:
		print("no floor?")

func attacked(player):
	print("attacked!")

	var impulse = self.global_transform.origin - player.global_transform.origin
	impulse = impulse.normalized()
	impulse *= 5 * player.scale.x

	mode = MODE_RIGID
	call_deferred("knockback", impulse)

	$Attacked.pitch_scale *= pow(1/2.0, randf() * 5/12.0)
	$Attacked.play()
	$Timer.start()
	emit_signal("attacked")

func knockback(impulse):
	collision_mask = 1
	axis_lock_angular_x = false
	axis_lock_angular_y = false
	axis_lock_angular_z = false
	apply_central_impulse(impulse)
	
	# random point on 2-sphere
	var random = Vector3()
	var u = randf() * 2 - 1
	var theta = randf() * 2 * PI
	random.x = cos(theta) * pow(1 - u * u, 0.5)
	random.y = sin(theta) * pow(1 - u * u, 0.5)
	random.z = u
	
	random *= PI + randf() * 2 * PI
	random *= scale.x
	angular_velocity = random

#	queue_die_on_impact = true

func _on_Timer_timeout():
	print("die")
	collision_mask = 0
	$Visuals/Particles.emitting = true
	$Visuals/Particles.one_shot = true
	$Visuals/Sprite3D.visible = false
	
	$Poof.pitch_scale *= pow(1/2.0, randf() * 5/12.0)
	$Poof.play()

func _on_Thing_body_entered(body):
	if queue_die_on_impact and body.name != "Player":
		_on_Timer_timeout()
