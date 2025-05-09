extends Control

@onready var level_container = $MarginContainer/LevelScrollContainer/VBoxContainer

@onready var main = self.get_node("/root/Main")
@onready var level_manager = self.get_node("/root/Main/Level")

var level_entry : PackedScene = preload("res://gui/levelentry.tscn") 

func _ready() -> void:
	for i in range(10):
		var entry = level_entry.instantiate()
		level_container.add_child(entry)
		entry.level = i
		entry.level_started.connect(on_level_started)

func on_level_started(level : int):
	main.current_state = main.GameState.STATE_PLAY
	level_manager.setup(level)

func _on_exit_button_pressed() -> void:
	self.get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	self.get_tree().quit()
