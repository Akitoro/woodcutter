extends Node2D

@onready var cuts : Node2D = $Cuts
@onready var sound_player : AudioStreamPlayer2D = $SawAudioStreamPlayer2D

@export var total_cuts : int = 3
@export var current_cuts : int = total_cuts :
	set(value):
		current_cuts = clampi(value, 0, total_cuts)

@export var is_selected : bool = false

var saw_line : Line2D = Line2D.new()

signal cut_made(start : Vector2, end : Vector2)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("wd_rightclick") and current_cuts > 0:
		if !is_selected:
			saw_line = Line2D.new()
			is_selected = true
			cuts.add_child(saw_line)
			sound_player.play(0.0)
			saw_line.add_point(get_global_mouse_position())
			saw_line.add_point(get_global_mouse_position())
	else:
		if is_selected:
			is_selected=false
			sound_player.stop()
			cut_made.emit(saw_line.get_point_position(0), saw_line.get_point_position(1))
			for child in cuts.get_children():
				child.queue_free()
			current_cuts -= 1

func _process(_delta: float) -> void:
	if is_selected:
		var origin = saw_line.get_point_position(0)
		var target = self.get_global_mouse_position()
		
		var angle = origin.angle_to_point(target) + PI
		
		#0 if horizontal, 1 if vertical
		var clipped_angle =  int(round(angle/PI*2)) % 2
		
		var next = Vector2.ZERO
		if clipped_angle == 0:
			next = Vector2(target.x, origin.y)
		else:
			next = Vector2(origin.x, target.y)
		saw_line.set_point_position(1, next)
