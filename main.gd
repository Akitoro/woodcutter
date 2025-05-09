extends Node2D

enum GameState {STATE_MENU, STATE_PLAY}

@onready var menu = $Menu
@onready var level = $Level

@onready var game_scenes : Dictionary[GameState, Object] = {
	GameState.STATE_MENU : menu,
	GameState.STATE_PLAY : level,
}

@onready var current_state : GameState = GameState.STATE_MENU :
	get:
		return current_state
	set(value):
		current_state = value
		for child in self.get_children():
			child.visible = false
		game_scenes.get(value).visible = true
		
func _ready() -> void:
	current_state = GameState.STATE_MENU
