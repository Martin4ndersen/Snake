extends Node2D

const tile_size : int = 40

# Called when the node is added to the scene and ready to execute.
func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	
	for x in range(viewport_size.x / tile_size):
		for y in range(viewport_size.y / tile_size):
			if (x + y) % 2 == 0:
				$Ground.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			else:
				$Ground.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))
