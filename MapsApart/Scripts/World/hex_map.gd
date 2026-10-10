
extends RefCounted
class_name HexMap
enum TerrainType {
	GRASS,
	WATER,
	MOUNTAIN
}
# The map's width and height, measured in hex tiles.
var width: int
var height: int

# Stores the coordinates of every tile that exists.
var tiles: Array[Vector2i] = []
var terrain: Dictionary = {}

func generate_map(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	tiles.clear()
	terrain.clear()

	for y in range(height):
		for x in range(width):
			var tile := Vector2i(x, y)
			tiles.append(Vector2i(x, y))
			if tile.x < 3:
				terrain[tile] = TerrainType.WATER
			elif tile.x > 5:
				terrain[tile] = TerrainType.MOUNTAIN
			else:
				terrain[tile] = TerrainType.GRASS
