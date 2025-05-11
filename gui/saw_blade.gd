extends Sprite2D

@export var amplitude = 300
@export var move_time = 2
@export var rotation_time = 0.1

func _ready() -> void:
	var move_tween = self.create_tween()
	move_tween.tween_property(self, "position", Vector2(amplitude, self.position.y), move_time)
	move_tween.tween_property(self, "position", Vector2(-amplitude, self.position.y), move_time)
	move_tween.set_loops(-1)
	move_tween.play()
	
	var rotate_tween = self.create_tween()
	rotate_tween.tween_property(self, "rotation", 2*PI, rotation_time)
	rotate_tween.tween_property(self, "rotation", 0, 0)
	rotate_tween.set_loops(-1)
	rotate_tween.play()
	
