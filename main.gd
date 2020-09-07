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
		w.color = Color.white
		walls.insert(n, w)

	# boundary walls
	var b_top = Beam.new()
	var b_right = Beam.new()
	var b_bottom = Beam.new()
	var b_left = Beam.new()
	# boundary positions
	b_top.setPosition(Vector2(0,10), Vector2(screenSize.x, 10))
	b_right.setPosition(Vector2(screenSize.x - 10, 0), Vector2(screenSize.x - 10, screenSize.y - 10))
	b_bottom.setPosition(Vector2(0,screenSize.y - 10), Vector2(screenSize.x - 10, screenSize.y - 10))
	b_left.setPosition(Vector2(10,0), Vector2(10, screenSize.y - 10))


	# append to walls
	walls.append(b_top)
	walls.append(b_right)
	walls.append(b_bottom)
	walls.append(b_left)


	lumen = Lumen.new(centerPos, 10, Color.white)



func _draw() -> void:
	lumen.pos = get_local_mouse_position() # follow mouse
#	lumen.pos = get_viewport_rect().size * 0.5 # center screen
	draw_lumen(lumen)

	# set wall position
#	wall.setPosition(centerPos + Vector2(200, -200), centerPos + Vector2(200, 200)) # default
#	wall.setPosition(centerPos + Vector2(500, -200), centerPos + Vector2(100, 200))
#	wall.color = Color.white
#	draw_beam(wall)

	for n in range(0, 360):
		var b = Beam.new()
		b.setPosition(lumen.pos, Vector2(1024, 600).rotated(deg2rad(n)))
		#b.setPosition(lumen.pos, centerPos + Vector2(get_viewport_rect().size.x * 0.5, 0).rotated(deg2rad(n)))

		var record = INF
		var closest:Vector2 = Vector2.ZERO

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
			b.color.a = 0.25
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
	draw_line(beam.posA, beam.posB, beam.color, 1, true)

func draw_lumen(lumen: Lumen) -> void:
	draw_circle(lumen.pos, lumen.radius, lumen.color)
