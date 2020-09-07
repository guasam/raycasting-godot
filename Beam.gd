extends Object
class_name Beam

var posA: Vector2
var posB: Vector2
var color: Color

func _init() -> void:
	color = Color.white
	color.a = 0.1

func setPosition(_posA: Vector2, _posB: Vector2) -> void:
	posA = _posA
	posB = _posB
#
#func pintersection(beam1: Beam, beam2: Beam) -> Vector2:
#	var a1 = beam1.posB.y - beam1.posA.y;
#	var b1 = beam1.posA.x - beam1.posB.x;
#	var c1 = a1 * beam1.posA.x + b1 * beam1.posA.y;
#	var a2 = beam2.posB.y - beam2.posA.y;
#	var b2 = beam2.posA.x - beam2.posB.x;
#	var c2 = a2 * beam2.posA.x + b2 * beam2.posA.y;
#	var denominator = a1 * b2 - a2 * b1;
#
#	if denominator == 0: return Vector2.INF
#
#	return Vector2(
#		(b2 * c1 - b1 * c2) / denominator,
#		(a1 * c2 - a2 * c1) / denominator
#	)


static func intersection(beam1: Beam, beam2: Beam):
	var x1 = beam1.posA.x
	var y1 = beam1.posA.y
	var x2 = beam1.posB.x
	var y2 = beam1.posB.y

	var x3 = beam2.posA.x
	var y3 = beam2.posA.y
	var x4 = beam2.posB.x
	var y4 = beam2.posB.y

	var denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

	# When the two lines are parallel or coincident the denominator is zero:
	if denominator == 0: return

	# The intersection point of the lines is found with one
	# of the following values of t or u
	var t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
	var u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator

	# The intersection point falls within the first
	# line segment if 0.0 ≤ t ≤ 1.0, and it falls within
	# the second line segment if 0.0 ≤ u ≤ 1.0
	if (t > 0 && t < 1 && u > 0 && u < 1):
		return Vector2(x1 + t * (x2 - x1), y1 + t * (y2 - y1))
