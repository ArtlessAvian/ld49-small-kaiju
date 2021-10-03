extends Spatial
tool

export var scene : PackedScene
export var other : PackedScene
export var max_radius = 10.0
export var spacing = 3.0
export var max_amount = 20
export var grid_like = false

func _ready():
	call_deferred("generate")

func generate():
	for i in range(get_child_count() - 1, -1, -1):
		remove_child(get_child(i))
	
	var queue = [Vector2(0, 0)]
	var explored = []
	for i in range(max_amount):
		if queue.empty():
			break
		
		var index = randi() % len(queue)
		var current = queue[index]
		queue.remove(index)
		explored.append(current)
		
		var child = scene.instance() if (other == null or randf() < 0.5) else other.instance()
		add_child(child)
		child.translation.x = current.x
		child.translation.z = current.y
		
		for k in range(10):
			var next : Vector2 = Vector2.RIGHT * spacing
			if not grid_like:
				next = next.rotated(randf() * 2 * PI)
			else:
				next = next.rotated(k * PI/2 + randf() * PI/8)
			next += current
			
			if next.length() > max_radius:
				continue
			
			if too_close(next, queue, explored):
				continue
			
			queue.append(next)

func too_close(next, queue, explored):
	for vec in explored:
		if next.distance_to(vec) < spacing * 0.99:
			return true
			
	for vec in queue:
		if next.distance_to(vec) < spacing * 0.99:
			return true
	
	return false
