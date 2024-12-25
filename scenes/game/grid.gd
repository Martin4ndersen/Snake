extends Node2D

const tile_size : int = 40

# Called when the node is added to the scene and ready to execute.
func _ready() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	
	for x in range(viewport_size.x / tile_size):
		for y in range(viewport_size.y / tile_size):
			if (x + y) % 2 == 0:
				$Ground.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
			else:
				$Ground.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))

# Returns a Vector2i array with the positions of all cells not containing an object.
func get_empty_cells() -> Array[Vector2i]:
	var viewport_size: Vector2 = get_viewport_rect().size	
	var used_cells: Array[Vector2i] = $Objects.get_used_cells()
	var empty_cells: Array[Vector2i] = []
	
	for x in range(viewport_size.x / tile_size):
		for y in range(viewport_size.y / tile_size):
			var cell: Vector2i = Vector2i(x, y)
			if cell not in used_cells:
				empty_cells.append(cell)

	return empty_cells
