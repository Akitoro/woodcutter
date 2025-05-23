extends Node

# Calculates integer bounding box
static func boundsi(vecs : Array[Variant]) -> Rect2i:
	var xs = vecs.map(func(v): return v.x)
	var ys = vecs.map(func(v): return v.y)
	
	if max(xs.size(), ys.size()) > 0:
		return Rect2i(Vector2(xs.min(), ys.min()), Vector2i(xs.max()-xs.min(), ys.max()-ys.min()))
	return Rect2i()

# Normalize Bounds of a collection by putting its upper left corner to (0,0)
static func get_normalizations(vecs : Array[Variant]) -> Array[Variant]:
	var bounds : Rect2i = Util.boundsi(vecs)
	return vecs.map(func(v): return v-bounds.position)

# Generate all Rotations of a normalized vector array
static func get_rotations(vecs: Array[Variant]) -> Array[Variant]:
	var bounds : Rect2i = Util.boundsi(vecs)
	var distances : Array[Variant] = [vecs]
	var rotate_by_90 : Array[Variant] = vecs
	for i in range(3):
		rotate_by_90 = rotate_by_90.map(func(v): return Vector2i(bounds.size.x-v.y, v.x))
		distances.append(rotate_by_90)
	return distances
	
static func connect_block(block1, block2, b1_dir : Vector2i):
	block1.connections[b1_dir].neighbor = block2
	block2.connections[-b1_dir].neighbor = block1

static func same_content(a1 : Array[Variant], a2:Array[Variant]) -> bool:
	if a1.size() != a2.size():
		return false
	for item1 in a1:
		if item1 not in a2:
			return false
	return true
	
