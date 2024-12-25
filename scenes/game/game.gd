extends Node2D

var snake_scene: PackedScene = preload("res://scenes/snake/snake.tscn")
var snake
var fruit_scene: PackedScene = preload("res://scenes/fruit/fruit.tscn")
var fruit
var is_fruit_eaten: bool = false

# Called when the node is added to the scene and ready to execute.
# This function creates a new instance of the Snake class, passing in the Grid node,
# and adds the snake as a child of the current node to manage it within the scene.
func _ready() -> void:
	snake = snake_scene.instantiate()
	snake.init($Grid/Objects, get_viewport_rect().size)
	snake.connect("snake_collision", Callable(self, "_on_snake_collision"))
	add_child(snake)
	
	add_fruit()
				
func _on_snake_collision():
	$UserInterface/Score.text = "0"
				
# Called every frame to update the game state. 'delta' represents the time elapsed since the last frame.
# This function handles player input, updates the movement timer, and moves and redraws the snake
# at a consistent interval based on the movement delay.
func _process(delta: float) -> void:
	snake.move_timer += delta
	snake.handle_input()
	
	if snake.move_timer >= snake.move_delay:
		$Grid/Objects.clear()
		snake.move()
		snake.move_timer = 0.0
		snake.draw()
		
		if not is_fruit_eaten and snake.get_head_position() == fruit.coords:
			is_fruit_eaten = true
			fruit.queue_free()
			snake.eat()
			
			# Convert the current score to an integer, increment it, and set it back as text
			var current_score: int = int($UserInterface/Score.text)
			var new_score: int = current_score + 1
			$UserInterface/Score.text = str(new_score)			
			
			# Add new fruit after a delay.
			await get_tree().create_timer(1.0).timeout
			add_fruit()
			is_fruit_eaten = false
		
	if not is_fruit_eaten:
		fruit.draw()

func add_fruit():
	var available_positions: Array[Vector2i] = $Grid.get_empty_cells()
	if available_positions.size() > 0:
		var random_index: int = randi() % available_positions.size()
		var fruit_position: Vector2i = available_positions[random_index]
		
		fruit = fruit_scene.instantiate()
		fruit.init($Grid/Objects, fruit_position)
		add_child(fruit)
	else:
		print("No available position to place fruit!")			
