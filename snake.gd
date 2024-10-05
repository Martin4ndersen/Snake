extends Node2D

var move_delay = 0.1
var move_timer = 0.0
var grid : TileMapLayer
var direction : Vector2
var snake
var snake_directions
var sprite_size : float = 40.0  # Size of the sprite in pixels
var window_size : Vector2


func _init(grid_node):
	grid = grid_node
	reset()

func _ready() -> void:
	window_size = get_viewport_rect().size

func handle_input():
	if Input.is_action_pressed("ui_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif Input.is_action_pressed("ui_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT

func move():
	# Move the snake's body
	for i in range(snake.size() - 1, 0, -1):
		snake[i] = snake[i - 1]
		snake_directions[i] = snake_directions[i - 1]
	
	# Move the snake's head in the current direction
	snake[0] += direction
	snake_directions[0] = direction

	if is_collision_with_edges() or is_collision_with_self():
		reset()

func reset():
	direction = Vector2.RIGHT
	snake = [Vector2(16, 7), Vector2(15, 7), Vector2(14, 7), Vector2(13, 7), Vector2(12, 7), Vector2(11, 7), Vector2(10, 7)]
	snake_directions = [Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT]  # Track directions for each part

func is_collision_with_self():
	var head = snake[0]
	
	for i in range(1, snake.size()):
		if head == snake[i]:
			return true
			
	return false

func is_collision_with_edges():
	var head = snake[0]

	if head.x < 0 or head.x > window_size.x / sprite_size - 1:
		return true

	if head.y < 0 or head.y > window_size.y / sprite_size - 1:
		return true

	return false

func draw():
	var atlas_coords: Vector2i
	
	for i in range(snake.size()):
		var part = snake[i]
		var part_direction = snake_directions[i]
		var previous_part_direction = snake_directions[i - 1]
	
		if i == 0: # head
			if part_direction == Vector2.UP:
				atlas_coords = Vector2i(3, 2)
			elif part_direction == Vector2.DOWN:
				atlas_coords = Vector2i(0, 2)
			elif part_direction == Vector2.LEFT:
				atlas_coords = Vector2i(1, 2)
			elif part_direction == Vector2.RIGHT:
				atlas_coords = Vector2i(2, 2)
		elif i == snake.size() - 1: # tail				
			if previous_part_direction == Vector2.RIGHT:
				atlas_coords = Vector2i(1, 3)
			elif previous_part_direction == Vector2.LEFT:
				atlas_coords = Vector2i(2, 3)
			elif previous_part_direction == Vector2.UP:
				atlas_coords = Vector2i(0, 3)
			elif previous_part_direction == Vector2.DOWN:
				atlas_coords = Vector2i(3, 3)
		else: # body
			if previous_part_direction == Vector2.UP and part_direction == Vector2.RIGHT:
				atlas_coords = Vector2i(3, 1)
			elif previous_part_direction == Vector2.UP and part_direction == Vector2.LEFT:
				atlas_coords = Vector2i(4, 1)
			elif previous_part_direction == Vector2.DOWN and part_direction == Vector2.RIGHT:
				atlas_coords = Vector2i(0, 1)
			elif previous_part_direction == Vector2.DOWN and part_direction == Vector2.LEFT:
				atlas_coords = Vector2i(1, 1)
			elif previous_part_direction == Vector2.RIGHT and part_direction == Vector2.DOWN:
				atlas_coords = Vector2i(4, 1)
			elif previous_part_direction == Vector2.RIGHT and part_direction == Vector2.UP:
				atlas_coords = Vector2i(1, 1)
			elif previous_part_direction == Vector2.LEFT and part_direction == Vector2.DOWN:
				atlas_coords = Vector2i(3, 1)
			elif previous_part_direction == Vector2.LEFT and part_direction == Vector2.UP:
				atlas_coords = Vector2i(0, 1)
			elif previous_part_direction == Vector2.UP and part_direction == Vector2.UP:
				atlas_coords = Vector2i(5, 1)
			elif previous_part_direction == Vector2.DOWN and part_direction == Vector2.DOWN:
				atlas_coords = Vector2i(5, 1)
			elif previous_part_direction == Vector2.LEFT and part_direction == Vector2.LEFT:
				atlas_coords = Vector2i(2, 1)
			elif previous_part_direction == Vector2.RIGHT and part_direction == Vector2.RIGHT:
				atlas_coords = Vector2i(2, 1)
	
		grid.set_cell(Vector2i(part.x, part.y), 0, atlas_coords)
