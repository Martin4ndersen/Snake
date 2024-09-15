extends Node2D

var direction = Vector2.RIGHT
var move_delay = 0.1
var move_timer = 0.0
var grid
var snake = [Vector2(7, 4), Vector2(6, 4), Vector2(5, 4), Vector2(4, 4), Vector2(3, 4), Vector2(2, 4), Vector2(1, 4)]
var snake_directions = [Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT, Vector2.RIGHT]  # Track directions for each part

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid = $Grid

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_timer += delta
	
	handle_input()
	
	if move_timer >= move_delay:
		move_snake()
		move_timer = 0.0
		
	draw_snake()
	
func handle_input():
	if Input.is_action_pressed("ui_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif Input.is_action_pressed("ui_down") and direction != Vector2.UP:
		direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT
	
func move_snake():
	# Move the snake's body
	for i in range(snake.size() - 1, 0, -1):
		snake[i] = snake[i - 1]
		snake_directions[i] = snake_directions[i - 1]
	
	# Move the snake's head in the current direction
	snake[0] += direction
	snake_directions[0] = direction
	
func draw_snake():
	grid.clear()

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
