extends GridMap
tool

export var regenerate : bool = false

func _process(delta):
	if regenerate:
		regenerate = false
		generate()

func generate():
	clear()
	var noise : OpenSimplexNoise = OpenSimplexNoise.new()
	for x in range(-90, 60):
		for z in range(-70, 30):
#			print(noise.get_noise_2d(x, z))
			var thing = 5
			thing = min(thing, get_height(x+1, z, noise))
			thing = min(thing, get_height(x-1, z, noise))
			thing = min(thing, get_height(x, z+1, noise))
			thing = min(thing, get_height(x, z-1, noise))
			for y in range(max(0, thing-1), get_height(x, z, noise)):
				set_cell_item(x, y, z, 0)

var memo : Dictionary = Dictionary()
func get_height(x, z, noise):
	var key = Vector2(x, z)

	if not memo.has(key):

		var out = noise.get_noise_2d(x, z) * 90 + x*x/120 + z*z/50 - 10
		memo[key] = floor(clamp(out, 0, 5))

	return memo[key]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
