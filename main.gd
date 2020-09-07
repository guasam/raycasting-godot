extends Node2D

# ====== Inventory  ===============================

var walls: Array
var lumen: Lumen

# ====== System Functions ===============================


# Initialization
func _init() -> void:
	# Set default clear color (background)
	VisualServer.set_default_clear_color(Color.black)


# Ready for lit the world
func _ready() -> void:
	# Shuffle random
	randomize()
	# Walls setup
	walls_setup(6)
	# Create lumen
	lumen = Lumen.new(get_viewport_rect().size * 0.5, 10, Color.white)


# Called by the engine (if defined) to draw the canvas item
func _draw() -> void:
	# Loop walls to draw
	for wall in walls: draw_beam(wall)
	# Draw boundaries
	draw_boundaries()
	# Lumen follow mouse and draw
	lumen.pos = get_local_mouse_position()
	draw_lumen(lumen)
	# Cast lumen rays
	cast_lumen_rays(lumen, walls, 360)


# Processing happens at every frame and updates as fast as possible
func _process(delta: float) -> void:
	# Drawing update
	update()


# ====== Custom Functions ===============================


# Draw beam
func draw_beam(beam: Beam) -> void:
	draw_line(beam.posA, beam.posB, beam.color, 1, true)


# Draw boundaries
func draw_boundaries(offset: int = 0) -> void:
	# Screen size
	var size: Vector2 = get_viewport_rect().size
	# Boundaries points on screen
	# Order : Top, Right, Bottom, Left
	var bounds: Array = [
		[Vector2(0, offset), Vector2(size.x, offset)],
		[Vector2(size.x - offset, 0), Vector2(size.x - offset, size.y - offset)],
		[Vector2(0,size.y - offset), Vector2(size.x - offset, size.y - offset)],
		[Vector2(offset,0), Vector2(offset, size.y - offset)],
	]
	# Loop bounds to draw
	for boundPos in bounds:
		# Create & draw beam for boundary
		var bound_beam = Beam.new(boundPos[0], boundPos[1], Color.gray)
		draw_beam(bound_beam)


# Draw lumen
func draw_lumen(lumen: Lumen) -> void:
	draw_circle(lumen.pos, lumen.radius, lumen.color)


# Random screen position
func screen_rand_pos() -> Vector2:
	var size = get_viewport_rect().size
	return Vector2(randi() % int(size.x), randi() % int(size.y))


# Walls setup
func walls_setup(walls_count: int = 2) -> void:
	# Loop walls count
	for n in range(0, walls_count):
		# Create beam for wall at random position
		var wall_beam = Beam.new(screen_rand_pos(), screen_rand_pos(), Color.white, 1)
		# Insert wall into array
		walls.insert(n, wall_beam)


# Cast lumen rays on walls
func cast_lumen_rays(lumen: Lumen, walls: Array, rays_count: int = 360) -> void:
	# Loop for rays
	for n in range(0, rays_count):
		# Ray records, Closest Ray cast point, Ray
		var record = INF
		var closest:Vector2 = Vector2.ZERO
		var ray = Beam.new(lumen.pos, Vector2(1024, 600).rotated(deg2rad(n)))

		# Loop for walls
		for wall in walls:
			var intersection = Beam.Intersection(ray, wall)
			# Cast ray on intersection point
			if (intersection):
				var d = lumen.pos.distance_to(intersection)
				if d < record:
					record = d
					closest = intersection

		# Got closest wall collision
		if closest:
			# Cast ray on closest wall
			ray.posB = closest

		# Draw ray and free object from memory to prevent memory leak
		draw_beam(ray)
		ray.free()

