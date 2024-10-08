# Represents a fruit that the snake can eat, rendered on a TileMapLayer.
extends Node2D

# The tile map layer where the fruit will be placed.
var tile_map_layer : TileMapLayer 

# The coordinates where the fruit will be placed.
var coords: Vector2i        
	  
# The atlas coordinates on the texture to use for this fruit.
var atlas_coords = Vector2i(0, 0)

# Initializes the fruit object.
func _init(tile_map_layer: TileMapLayer, coords: Vector2i) -> void:
	self.tile_map_layer = tile_map_layer
	self.coords = coords

# Draws the fruit on the tile map layer.
func draw() -> void:
	tile_map_layer.set_cell(coords, 0, atlas_coords)
