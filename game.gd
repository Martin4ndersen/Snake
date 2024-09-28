extends Node2D

var Snake = load("res://snake.gd")
var snake

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snake = Snake.new($Grid)
	add_child(snake)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	snake.move_timer += delta
	snake.handle_input()
	
	if snake.move_timer >= snake.move_delay:
		$Grid.clear()
		snake.move()
		snake.move_timer = 0.0
		snake.draw()
