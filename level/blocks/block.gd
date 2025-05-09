extends CharacterBody2D

class Info:
	var neighbor : Node2D
	var collision : CollisionShape2D
	
	func _init(neighbor1, collision1) -> void:
		self.neighbor = neighbor1
		self.collision = collision1
	
@onready var wood : CollisionShape2D = $SquareCollision
@onready var edges : Node2D = $SquareCollision/Edges

@onready var connections : Dictionary[Vector2i, Info] = {
	Vector2i.DOWN : Info.new(null, $SquareCollision/Edges/N/North),
	Vector2i.UP : Info.new(null, $SquareCollision/Edges/S/South),
	Vector2i.LEFT : Info.new(null, $SquareCollision/Edges/E/East),
	Vector2i.RIGHT : Info.new(null, $SquareCollision/Edges/W/West),
}

#reference to selected object
static var is_selected : Node2D = null

func calculated_size() -> Vector2:
	return wood.shape.size * wood.scale
	
func _physics_process(delta: float) -> void:
	if is_selected == self:
		self.move(Vector2.ZERO, delta, [])
	
func _input(_event):
	if wood.shape.get_rect().has_point(get_local_mouse_position()):
		if Input.is_action_pressed("wd_leftclick") and is_selected == null:
			is_selected = self
		elif not Input.is_action_pressed("wd_leftclick") and is_selected == self:
			is_selected = null
		if Input.is_action_just_pressed("wd_rotate"):
			var center = self.global_position
			self.rotated(center, [])
	
func rotated(rotation_center: Vector2, visited: Array[Node2D]):
	visited.append(self)
	
	var rotation_transform : Transform2D = Transform2D(PI/2, rotation_center)
	self.global_position = rotation_transform * (self.global_position - rotation_center)
	self.rotate(PI/2)
	for direction in connections.keys():
		var neighbor = connections.get(direction).neighbor
		if neighbor != null and neighbor not in visited:
			neighbor.rotated(rotation_center, visited)
	
	#swap connections
	var next : Dictionary[Vector2i, Info] = {}
	for direction : Vector2i in connections.keys():
		#90° degree rotation
		var rotated_direction = Vector2i(-direction.y, direction.x)
		next[rotated_direction] = connections.get(direction)
	connections = next

func move(offset: Vector2i, delta: float, visited: Array[Node2D]):
	visited.append(self)
	var target =  get_global_mouse_position()-Vector2(offset)*self.calculated_size()
	self.global_position = target
	
	#Recursively visit all unvisited neighbors and update each position
	for direction in connections.keys():
		var neighbor = connections.get(direction).neighbor
		if neighbor != null and neighbor not in visited:
			neighbor.move(offset+direction, delta, visited)

func _on_saw_cut_made(start: Vector2, end: Vector2) -> void:
	for direction in connections.keys():
		var info : Info = connections.get(direction)
		
		var segment : SegmentShape2D = info.collision.shape
		var from_b = to_global(segment.a)
		var to_b = to_global(segment.b)
		
		if Geometry2D.segment_intersects_segment(start, end, from_b, to_b) != null:
			connections[direction].neighbor = null
