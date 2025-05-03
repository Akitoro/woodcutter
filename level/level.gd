extends Node2D

var woodblock : PackedScene = preload("res://level/blocks/block.tscn")

@onready var cut_label = $HUD/ProgressBar/CutLabel
@onready var cut_progressbar = $HUD/ProgressBar

@onready var saw = $Saw
@onready var block1 = $Blocks/Block1
@onready var block2 = $Blocks/Block2
@onready var block3 = $Blocks/Block3
@onready var block4 = $Blocks/Block4
	
func _ready() -> void:
	cut_label.text = "Cuts: %s" % 3
	Util.connect_block(block1, block2, Vector2i.RIGHT)
	Util.connect_block(block2, block3, Vector2i.DOWN)
	Util.connect_block(block3, block4, Vector2i.LEFT)
	Util.connect_block(block4, block1, Vector2i.UP)
	
	saw.cut_made.connect(block1._on_saw_cut_made)
	saw.cut_made.connect(block2._on_saw_cut_made)
	saw.cut_made.connect(block3._on_saw_cut_made)
	saw.cut_made.connect(block4._on_saw_cut_made)

func _process(delta: float) -> void:
	cut_progressbar.value = cut_progressbar.min_value + (cut_progressbar.max_value-cut_progressbar.min_value)*(float(saw.current_cuts)/float(saw.total_cuts))
	cut_label.text = "%s/%s" % [saw.current_cuts, saw.total_cuts]
