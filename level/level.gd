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
	
	var one = blocks_node.get_child(0)
	one.move(self.get_viewport_rect().size / 2)
	
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

func _on_saw_node_cut_made(start: Vector2, end: Vector2) -> void:
	self.update_cut()
