extends Node2D

var woodblock : PackedScene = preload("res://level/blocks/block.tscn")
var util  = preload("res://util.gd")

@onready var cut_label = $HUD/ProgressBar/CutLabel
@onready var cut_progressbar = $HUD/ProgressBar
@onready var reset_button = $HUD/ResetButton

@onready var saw = $Saw
@onready var blocks = $Blocks
	
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	cut_progressbar.value = cut_progressbar.min_value + (cut_progressbar.max_value-cut_progressbar.min_value)*(float(saw.current_cuts)/float(saw.total_cuts))
	cut_label.text = "%s/%s" % [saw.current_cuts, saw.total_cuts]

func setup(level : int):
	cut_label.text = "Cuts: %s" % 3
	
	var block1 = woodblock.instantiate()
	var block2 = woodblock.instantiate()
	var block3 = woodblock.instantiate()
	var block4 = woodblock.instantiate()
	
	blocks.add_child(block1)
	blocks.add_child(block2)
	blocks.add_child(block3)
	blocks.add_child(block4)
	
	util.connect_block(block1, block2, Vector2i.RIGHT)
	util.connect_block(block2, block3, Vector2i.DOWN)
	util.connect_block(block3, block4, Vector2i.LEFT)
	util.connect_block(block4, block1, Vector2i.UP)
	
	saw.cut_made.connect(block1._on_saw_cut_made)
	saw.cut_made.connect(block2._on_saw_cut_made)
	saw.cut_made.connect(block3._on_saw_cut_made)
	saw.cut_made.connect(block4._on_saw_cut_made)

func clear():
	for child in blocks.get_children():
		child.queue_free()
	self.setup(0)
	saw.current_cuts = saw.total_cuts

func _on_reset_button_pressed() -> void:
	self.clear()
