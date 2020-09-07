extends Object

class_name Lumen

# ====== Properties  ===============================

var pos: Vector2
var color: Color
var radius: float

# ====== System Functions  ===============================


func _init(_pos: Vector2, _radius: float, _color: Color = Color.white) -> void:
	# set properties
	pos = _pos
	color = _color
	radius = _radius
