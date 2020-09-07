extends Node2D

var wall: Beam
var lumen: Lumen
var walls: Array

var centerPos: Vector2

func _init() -> void:
	VisualServer.set_default_clear_color(Color.black)

func _ready() -> void:
	var screenSize = get_viewport_rect().size
	centerPos = screenSize * 0.5
	wall = Beam.new()

	# random walls
	randomize()
	for n in range(0, 6):
		var w = Beam.new()
		var a = Vector2(randi() % int(screenSize.x), randi() % int(screenSize.y))
		var b = Vector2(randi() % int(screenSize.x), randi() % int(screenSize.y))
		w.setPosition(a, b)
		w.color = Color.red
		walls.insert(n, w)


	lumen = Lumen.new(centerPos, 10, Color.gray)

func _draw() -> void:
	lumen.pos = get_local_mouse_position() # follow mouse
#	lumen.pos = get_viewport_rect().size * 0.5 # center screen
	draw_lumen(lumen)

	# set wall position
	wall.setPosition(centerPos + Vector2(200, -200), centerPos + Vector2(200, 200)) # default
#	wall.setPosition(centerPos + Vector2(500, -200), centerPos + Vector2(100, 200))
	wall.color = Color.white
	draw_beam(wall)

	for n in range(0, 359, 10):
		var b = Beam.new()
		b.setPosition(lumen.pos, centerPos + Vector2(get_viewport_rect().size.x * 0.5, 0).rotated(deg2rad(n)))
		# wall intersection
#		var intersection = Beam.intersection(b, wall) # default
		var record = INF
		var closest = null

		for w in walls:
			var intersection = Beam.intersection(b, w)
			# cast ray towards intersection point
			if (intersection):
				var d = lumen.pos.distance_to(intersection)
				if d < record:
					record = d
					closest = intersection

		if closest:
			b.color = Color.white
			b.posB = closest
			# draw beam
			draw_beam(b)
		# free up beam object
		b.free()


	for w in walls:
		draw_beam(w)


func _process(delta: float) -> void:
	update()
	pass

func draw_beam(beam: Beam) -> void:
	draw_line(beam.posA, beam.posB, beam.color, 1)

func draw_lumen(lumen: Lumen) -> void:
	draw_circle(lumen.pos, lumen.radius, lumen.color)
