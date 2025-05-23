extends Node2D

enum GameState {STATE_MENU, STATE_PLAY}

@onready var game_scenes : Dictionary[GameState, Node] = {
	GameState.STATE_MENU : $Menu,
	GameState.STATE_PLAY : $Level,
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
	print(Util.get_normalizations([Vector2i(1,1), Vector2i(2,2)]))
	print(Util.get_rotations(Util.get_normalizations([Vector2i(1,1), Vector2i(2,2)])))
