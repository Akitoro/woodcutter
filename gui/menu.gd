extends Control

@onready var level_container = $MarginContainer/LevelScrollContainer/VBoxContainer
@onready var addinfo_label = $AdditionalInfoLabel

@onready var main_node = self.get_node("/root/Main")
@onready var level_node = self.get_node("/root/Main/Level")

var level_entry_scene : PackedScene = preload("res://gui/level_entry.tscn") 

func _ready() -> void:
	# Load levels into corresponding level entries
	var all_levels : Array[Data.LevelData] = Data.LevelData.load_all_levels()
	for i in all_levels.size():
		var level_entry = level_entry_scene.instantiate()
		level_container.add_child(level_entry)
		level_entry.level = all_levels[i]
		level_entry.level_started.connect(on_level_started)
		level_entry.level_hovered.connect(on_level_hovered)

func on_level_started(level : Data.LevelData):
	main_node.current_state = main_node.GameState.STATE_PLAY
	level_node.level = level

func _on_exit_button_pressed() -> void:
	self.get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	self.get_tree().quit()

func on_level_hovered(level : Data.LevelData) -> void:
	pass
