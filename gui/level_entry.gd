extends MarginContainer

@onready var id_label : Label = $PanelContainer/MarginContainer/HBoxContainer/LevelIDLabel
@onready var name_label : Label = $PanelContainer/MarginContainer/HBoxContainer/LevelNameLabel

@onready var level : Data.LevelData:
	set(value):
		level = value
		if level != null:
			id_label.text = str(level.id)
			name_label.text = str(level.name)

signal level_started(level : Data.LevelData)
signal level_hovered(level : Data.LevelData)

func _on_level_play_button_pressed() -> void:
	level_started.emit(self.level)

func _on_mouse_entered() -> void:
	level_hovered.emit(self.level)
