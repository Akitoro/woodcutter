extends MarginContainer

@onready var level_label : Label = $MarginContainer/HBoxContainer/LevelLabel

@onready var level : int = -1:
	get:
		return level
	set(value):
		level = value
		level_label.text = str(level)
		
signal level_started(level: int)

func _on_level_play_button_pressed() -> void:
	level_started.emit(self.level)
