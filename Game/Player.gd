extends KinematicBody

var horizontal_vel : Vector3 = Vector3()
var vertical_vel : Vector3 = Vector3()

var was_on_floor = false

var gravity : Vector3 = Vector3.DOWN * 20
var hard_gravity : Vector3 = Vector3.DOWN * 40

export var target_scale = 1

var tier = 0
const tiers = [0, 2, 4, 6]
var first_input = 0

func _ready():
	pass

func _physics_process(delta):
	if translation.y < -10:
		translation = Vector3.UP * 10
	
	var input = Vector3()
	input += Vector3.BACK * Input.get_action_strength("ui_down")
	input += Vector3.FORWARD * Input.get_action_strength("ui_up")
	input += Vector3.LEFT * Input.get_action_strength("ui_left")
	input += Vector3.RIGHT * Input.get_action_strength("ui_right")
	if input.length_squared() > 1:
		input = input.normalized()
	
	if first_input == 0 and input != Vector3.ZERO:
		first_input = OS.get_system_time_msecs()
		
	if was_on_floor:
#		if input.length_squared() < 0.1:
#			horizontal_vel = horizontal_vel.move_toward(input * 5, delta * 90)
#		elif horizontal_vel.length_squared() > 0.1 and input.angle_to(horizontal_vel) > PI/2:
#			horizontal_vel = horizontal_vel.move_toward(input * 5, delta * 90)
#		else:
		horizontal_vel = horizontal_vel.move_toward(input * 5 * (scale.x + 1) / 2, delta * 90)
	else:
		horizontal_vel = horizontal_vel.move_toward(input * 5 * (scale.x + 1) / 2, delta * 10)

	if was_on_floor:
		if Input.is_action_pressed("ui_select"):
			vertical_vel += Vector3.UP * 10
	
	if Input.is_action_pressed("ui_select") and vertical_vel.y > -0.1:
		vertical_vel += gravity * delta
	else:
		vertical_vel += hard_gravity * delta
	
	var vel : Vector3 = move_and_slide(horizontal_vel + vertical_vel, Vector3.UP, false)
	vertical_vel = vel.project(Vector3.UP)
	horizontal_vel = vel - vertical_vel
	
	was_on_floor = is_on_floor()

	# stuff for children
	if Input.is_action_pressed("swing"):
		$AnimationTree.set("parameters/conditions/Owch", false)
		if input.x < 0 or (input.x == 0 and $Sprite3D.flip_h):
			$AnimationTree.set("parameters/conditions/SwingLeft", true)
		if input.x > 0 or (input.x == 0 and (not $Sprite3D.flip_h)):
			$AnimationTree.set("parameters/conditions/SwingRight", true)
	else:
		$AnimationTree.set("parameters/conditions/SwingLeft", false)
		$AnimationTree.set("parameters/conditions/SwingRight", false)

	$AnimationTree.set("parameters/conditions/Walking", (input.x != 0 or input.z != 0) and is_on_floor())
	$AnimationTree.set("parameters/conditions/NotWalking", (input.x == 0 and input.z == 0) or not is_on_floor())
	if $AnimationTree.get("parameters/playback").get_current_node() == "Walk" and input.x != 0:
		$Sprite3D.flip_h = input.x < 0
	
	$Offset/Camera.fov = move_toward($Offset/Camera.fov, 70 if Input.is_action_pressed("ui_cancel") else 40, 60 * delta)

	scale = scale.move_toward(Vector3.ONE * target_scale, 1 * delta)
	$AnimationPlayer.playback_speed = 1/scale.x

func _on_Hitbox_body_entered(body):
	if body.get("tier") != null and scale.x >= tiers[body.tier]:
		body.attacked(self)
		target_scale += [0.05, 0.1, 0.5, 1][tier]
	else:
		$AnimationTree.set("parameters/conditions/Owch", true)
		horizontal_vel.x += 10 * scale.x * (1 if $Sprite3D.flip_h else -1)
		print("owch")
