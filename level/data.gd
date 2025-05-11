extends Node

class BlockComponent:
	var elements : Array[Vector2i]
	
	func _init(cmpnt_elements : Array[Vector2i]) -> void:
		self.elements = cmpnt_elements
	
class LevelData:
	static var current_id : int = 0
	
	var id : int
	var name : String
	var description : String
	var total_cuts : int
	var start : Array[BlockComponent]
	var goal : Array[BlockComponent]
	
	func _init(lvl_name, lvl_description, lvl_total_cuts, lvl_start, lvl_goal) -> void:
		self.name = lvl_name
		self.description = lvl_description
		self.total_cuts = lvl_total_cuts
		self.start = lvl_start
		self.goal = lvl_goal
		self.id = LevelData.current_id
		LevelData.current_id += 1
	
	static func load_all_levels() -> Array[LevelData]:
		var level_files : PackedStringArray = ResourceLoader.list_directory("res://assets/levels/")
		
		var all_levels : Array[LevelData] = []
		for file_path in level_files:
			all_levels.append(load_level_by_path("res://assets/levels/" + file_path))
		return all_levels
	
	static func load_level_by_id(lvl_id : int) -> LevelData:
		return LevelData.load_level_by_path("res://assets/levels/level%d.json" % lvl_id)
		
	static func load_level_by_path(path : String) -> LevelData:
		var file = FileAccess.open(path, FileAccess.READ)
		var error = FileAccess.get_open_error()
		
		if error != OK:
			return null
		
		var level_data = JSON.parse_string(file.get_as_text())
		
		var tmp_start : Array[BlockComponent] = []
		var tmp_goal : Array[BlockComponent] = []
		
		# Load start and goal components
		for component in level_data["start"]:
			var blocks : Array[Vector2i] = []
			for vec in component["components"]:
				blocks.append(Vector2i(vec[0], vec[1]))
			tmp_start.append(BlockComponent.new(blocks))
		
		for component in level_data["goal"]:
			var blocks : Array[Vector2i] = []
			for vec in component["components"]:
				blocks.append(Vector2i(vec[0], vec[1]))
			tmp_goal.append(BlockComponent.new(blocks))
		
		return LevelData.new(
			level_data["name"], 
			level_data["description"], 
			int(level_data["total_cuts"]),
			tmp_start,
			tmp_goal)
