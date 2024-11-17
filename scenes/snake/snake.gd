extends Node2D

var move_delay: float = 0.1
var move_timer: float = 0.0
var tile_map_layer : TileMapLayer
var direction : Vector2i
var snake_segments: Array[Vector2i]
var snake_directions: Array[Vector2i]
var sprite_size : float = 40.0  # Size of the sprite in pixels
var window_size : Vector2i
signal snake_collision

# Constructor for the snake object. It initializes the snake by passing a reference to the grid node
# and calls the `reset` function to set up the initial state of the snake.
func init(tile_map_layer):
	self.tile_map_layer = tile_map_layer
	reset()

# Called when the node is added to the scene and ready to execute.
# This function retrieves the size of the current viewport (game window) and stores it in `window_size`,
# which will be used to check for edge collisions.
func _ready() -> void:
	window_size = get_viewport_rect().size
	connect("snake_collision", Callable(self, "reset"))

# Handles player input to change the snake's direction based on arrow key presses.
# The snake can only move in a direction that is not opposite to its current direction,
# preventing it from reversing into itself.
func handle_input():
	if Input.is_action_pressed("ui_up") and direction != Vector2i.DOWN:
		direction = Vector2i.UP
	elif Input.is_action_pressed("ui_down") and direction != Vector2i.UP:
		direction = Vector2i.DOWN
	elif Input.is_action_pressed("ui_left") and direction != Vector2i.RIGHT:
		direction = Vector2i.LEFT
	elif Input.is_action_pressed("ui_right") and direction != Vector2i.LEFT:
		direction = Vector2i.RIGHT

# Moves the snake's body and head, and checks for collisions with edges or itself.
# The snake's body segments follow the movement of the segment ahead of them, while the head moves in the current direction.
# If a collision with the window edges or the snake's own body occurs, the snake is reset.
func move():
	# Move the snake's body
	for i in range(snake_segments.size() - 1, 0, -1):
		snake_segments[i] = snake_segments[i - 1]
		snake_directions[i] = snake_directions[i - 1]
	
	# Move the snake's head in the current direction
	snake_segments[0] += direction
	snake_directions[0] = direction

	if is_collision_with_edges() or is_collision_with_self():
		emit_signal("snake_collision")

func get_head_position() -> Vector2i:
	return snake_segments[0]

# Grows the snake by adding a new segment at the end.
func eat() -> void:
	var last_segment = snake_segments[snake_segments.size() - 1]
	var last_direction = snake_directions[snake_directions.size() - 1]
	# Add a new segment in the opposite direction of the last one
	snake_segments.append(last_segment - last_direction)
	snake_directions.append(last_direction)

func reset():
	direction = Vector2i.RIGHT
	snake_segments = [Vector2i(16, 7), Vector2i(15, 7), Vector2i(14, 7)]
	snake_directions = [Vector2i.RIGHT, Vector2i.RIGHT, Vector2i.RIGHT]  # Track directions for each segment

# Checks if the snake's head collides with any segment of its own body.
# This function iterates through all segments of the snake's body (excluding the head)
# and checks if the head occupies the same position as any of the body segments.
# If a collision is detected, it returns `true`. Otherwise, it returns `false`.
func is_collision_with_self():
	var head = snake_segments[0]
	
	for i in range(1, snake_segments.size()):
		if head == snake_segments[i]:
			return true
			
	return false

# Checks if the snake's head collides with the edges of the game window.
# The function checks whether the head's x or y position goes outside the window's boundaries.
# If the head crosses the boundaries, it returns `true`. Otherwise, it returns `false`.
func is_collision_with_edges():
	var head = snake_segments[0]

	if head.x < 0 or head.x > window_size.x / sprite_size - 1:
		return true

	if head.y < 0 or head.y > window_size.y / sprite_size - 1:
		return true

	return false

# Draws the snake on the grid using atlas coordinates for different segments of the snake (head, body, and tail).
# Each segment of the snake is drawn according to its position and direction, and different atlas coordinates are used
# to represent the head, tail, and body based on their direction and the connection between segments.
func draw():
	var atlas_coords: Vector2i
	
	for i in range(snake_segments.size()):
		var segment = snake_segments[i]
		var segment_direction = snake_directions[i]
		var previous_segment_direction = snake_directions[i - 1]
	
		if i == 0: # head
			if segment_direction == Vector2i.UP:
				atlas_coords = Vector2i(3, 2)
			elif segment_direction == Vector2i.DOWN:
				atlas_coords = Vector2i(0, 2)
			elif segment_direction == Vector2i.LEFT:
				atlas_coords = Vector2i(1, 2)
			elif segment_direction == Vector2i.RIGHT:
				atlas_coords = Vector2i(2, 2)
		elif i == snake_segments.size() - 1: # tail
			if previous_segment_direction == Vector2i.RIGHT:
				atlas_coords = Vector2i(1, 3)
			elif previous_segment_direction == Vector2i.LEFT:
				atlas_coords = Vector2i(2, 3)
			elif previous_segment_direction == Vector2i.UP:
				atlas_coords = Vector2i(0, 3)
			elif previous_segment_direction == Vector2i.DOWN:
				atlas_coords = Vector2i(3, 3)
		else: # body
			if previous_segment_direction == Vector2i.UP and segment_direction == Vector2i.RIGHT:
				atlas_coords = Vector2i(3, 1)
			elif previous_segment_direction == Vector2i.UP and segment_direction == Vector2i.LEFT:
				atlas_coords = Vector2i(4, 1)
			elif previous_segment_direction == Vector2i.DOWN and segment_direction == Vector2i.RIGHT:
				atlas_coords = Vector2i(0, 1)
			elif previous_segment_direction == Vector2i.DOWN and segment_direction == Vector2i.LEFT:
				atlas_coords = Vector2i(1, 1)
			elif previous_segment_direction == Vector2i.RIGHT and segment_direction == Vector2i.DOWN:
				atlas_coords = Vector2i(4, 1)
			elif previous_segment_direction == Vector2i.RIGHT and segment_direction == Vector2i.UP:
				atlas_coords = Vector2i(1, 1)
			elif previous_segment_direction == Vector2i.LEFT and segment_direction == Vector2i.DOWN:
				atlas_coords = Vector2i(3, 1)
			elif previous_segment_direction == Vector2i.LEFT and segment_direction == Vector2i.UP:
				atlas_coords = Vector2i(0, 1)
			elif previous_segment_direction == Vector2i.UP and segment_direction == Vector2i.UP:
				atlas_coords = Vector2i(5, 1)
			elif previous_segment_direction == Vector2i.DOWN and segment_direction == Vector2i.DOWN:
				atlas_coords = Vector2i(5, 1)
			elif previous_segment_direction == Vector2i.LEFT and segment_direction == Vector2i.LEFT:
				atlas_coords = Vector2i(2, 1)
			elif previous_segment_direction == Vector2i.RIGHT and segment_direction == Vector2i.RIGHT:
				atlas_coords = Vector2i(2, 1)
	
		tile_map_layer.set_cell(Vector2i(segment.x, segment.y), 0, atlas_coords)
