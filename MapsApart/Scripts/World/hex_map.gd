
extends RefCounted
class_name HexMap

# The map's width and height, measured in hex tiles.
var width: int
var height: int

# Stores the coordinates of every tile that exists.
var tiles: Array[Vector2i] = []


func generate_map(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	tiles.clear()

	for y in range(height):
		for x in range(width):
			tiles.append(Vector2i(x, y))
