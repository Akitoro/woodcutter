extends Node

## Calculates bounding box
static func bounds(vecs : Array[Variant]) -> Rect2:
	var xs = vecs.map(func(v): return v.x)
	var ys = vecs.map(func(v): return v.y)
	
	if max(xs.size(), ys.size()) > 0:
		var rect = Rect2(Vector2(xs.min(), ys.min()), Vector2())
		rect.end = Vector2(xs.max(), ys.max())
		return rect
	return Rect2()

static func connect_block(block1, block2, b1_dir : Vector2i):
	block1.connections[b1_dir].neighbor = block2
	block2.connections[-b1_dir].neighbor = block1
