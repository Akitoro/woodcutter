extends Node2D

var woodblock : PackedScene = preload("res://level/blocks/block.tscn")
var util  = preload("res://util.gd")

@onready var main = self.get_node("/root/Main")
@onready var cut_label = $HUD/ProgressBar/CutLabel
@onready var cut_progressbar = $HUD/ProgressBar
@onready var reset_button = $HUD/ResetButton
@onready var saw_node = $Saw
@onready var blocks_node = $Blocks

var level : Data.LevelData :
	set(value):
		if value != null:
			level = value
			self.clear()
			self.initialize(value)
			saw_node.total_cuts = level.total_cuts
			saw_node.current_cuts = saw_node.total_cuts
			self.update_cut()
			
		
func initialize(level : Data.LevelData) -> void:
	# very inefficient loading function thats adds every connection twice
	# loops through every block of each component and connect neighbors
	for component in level.start:
		var tmp_blocks = []
		for block in component.elements:
			var tmp_block = woodblock.instantiate()
			tmp_blocks.append(tmp_block)
			blocks_node.add_child(tmp_block)
			saw_node.cut_made.connect(tmp_block._on_saw_cut_made)
		
		for i in range(len(tmp_blocks)):
			var block_pos = component.elements[i]
			var block_ref = tmp_blocks[i]
			for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:	
				var neighbor_idx = component.elements.find(direction+block_pos)
				if neighbor_idx != -1:
					var neighbor_ref = tmp_blocks[neighbor_idx]
					util.connect_block(block_ref, neighbor_ref, -direction)
	
		var one : Node2D  = tmp_blocks[0]
		one.move(self.get_viewport_rect().size / 2)

# Win Checking Code
func is_finished() -> bool:
	# Retrieve all goal components and current components
	var normalized_goals = level.goal.map(func(comps): return Util.get_normalizations(comps.elements))
	# Retrieve positions of each component
	var normalized_currs = []
	self.get_components(normalized_currs)
	normalized_currs = normalized_currs.map(Util.get_normalizations)
	
	# Check if all components have a rotated matching
	while !normalized_goals.is_empty():
		var goal : Array[Variant] = normalized_goals.pop_front()
		var found_i = -1
		for i in range(len(normalized_currs)):
			var curr = normalized_currs[i]
			if self.is_rotation(curr, goal):
				found_i = i
				break
		if found_i == -1:
			return false
		else:
			normalized_currs.remove_at(found_i)
	return true
				
func is_rotation(normalized_curr, normalized_goal) -> bool:
	for curr_rotation in Util.get_rotations(normalized_curr):
		if Util.same_content(curr_rotation, normalized_goal):
			return true
	return false	
	
func get_components(total_positions : Array[Variant]=[]) -> Array[Variant]:
	var queue : Array[Node] = blocks_node.get_children()
	var total_components : Array[Variant]
	while !queue.is_empty():
		var first_node = queue.pop_front()
		var positions : Array[Vector2i] = []
		var component : Array[Variant] = first_node.get_component([], Vector2i.ZERO, positions)
		queue = queue.filter(func(q): return q not in component)
		total_components.append(component)
		total_positions.append(positions)
	return total_components

func clear():
	for child in blocks_node.get_children():
		child.free()

func update_cut():
	cut_progressbar.value = cut_progressbar.min_value + (cut_progressbar.max_value-cut_progressbar.min_value)*(float(saw_node.current_cuts)/float(saw_node.total_cuts))
	cut_label.text = "%s/%s" % [saw_node.current_cuts, saw_node.total_cuts]
	
func _on_reset_button_pressed() -> void:
	self.level = self.level

func _on_home_button_pressed() -> void:
	main.current_state = main.GameState.STATE_MENU
	self.clear()

func _on_saw_cut_made(start: Vector2, end: Vector2) -> void:
	self.update_cut()
	# wait for all blocks being cutted
	await get_tree().create_timer(1).timeout
	print(self.is_finished())
	#for c in self.get_components():
		#print(c.map(func(n:Node):return n.get_instance_id()))
