extends Node2D

var Snake = load("res://snake.gd")
var snake

# Called when the node is added to the scene and ready to execute.
# This function creates a new instance of the Snake class, passing in the Grid node,
# and adds the snake as a child of the current node to manage it within the scene.
func _ready() -> void:
	snake = Snake.new($Grid/Objects)
	add_child(snake)
				
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
