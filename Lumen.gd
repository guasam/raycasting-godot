extends Object
class_name Lumen

var pos: Vector2
var radius: float
var color: Color

func _init(_pos: Vector2, _radius: float, _color: Color) -> void:
	# set properties
	pos = _pos
	color = _color
	radius = _radius
