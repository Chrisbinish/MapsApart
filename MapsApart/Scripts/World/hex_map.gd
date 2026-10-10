
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
var map_seed: int = 67890
# Stores the coordinates of every tile that exists.
var tiles: Array[Vector2i] = []
var terrain: Dictionary = {}


func generate_map(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	tiles.clear()
	terrain.clear()

	var rng := RandomNumberGenerator.new()
	rng.seed = map_seed

	var water_centers: Array[Vector2i] = []
	var mountain_centers: Array[Vector2i] = []

	# Choose centers for water and mountain regions.
	for i in range(30):
		water_centers.append(
			Vector2i(rng.randi_range(0, width - 1), rng.randi_range(0, height - 1))
		)
	for i in range(10):	
		mountain_centers.append(
			Vector2i(rng.randi_range(0, width - 1), rng.randi_range(0, height - 1))
		)

	for y in range(height):
		for x in range(width):
			var tile := Vector2i(x, y)
			tiles.append(tile)

			var nearest_water: int = 999
			var nearest_mountain: int = 999

			for center in water_centers:
				var distance: int = absi(tile.x - center.x) + absi(tile.y - center.y)
				nearest_water = mini(nearest_water, distance)

			for center in mountain_centers:
				var distance: int = absi(tile.x - center.x) + absi(tile.y - center.y)
				nearest_mountain = mini(nearest_mountain, distance)

			if nearest_water <= 1:
				terrain[tile] = TerrainType.WATER
			elif nearest_mountain <= 1:
				terrain[tile] = TerrainType.MOUNTAIN
			else:
				terrain[tile] = TerrainType.GRASS
