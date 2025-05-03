extends Node2D

@onready var cuts : Node2D = $Cuts

@export var total_cuts : int = 3
@export var current_cuts : int = total_cuts
@export var is_selected : bool = false

var saw_line : Line2D = Line2D.new()

signal cut_made(start : Vector2, end : Vector2)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("wd_rightclick"):
		if !is_selected:
			saw_line = Line2D.new()
			is_selected = true
			cuts.add_child(saw_line)
			saw_line.add_point(get_global_mouse_position())
			saw_line.add_point(get_global_mouse_position())
	else:
		if is_selected:
			is_selected=false
			cut_made.emit(saw_line.get_point_position(0), saw_line.get_point_position(1))
			for child in cuts.get_children():
				child.queue_free()
			current_cuts -= 1

func _process(_delta: float) -> void:
	if is_selected:
		saw_line.set_point_position(1, get_global_mouse_position())
