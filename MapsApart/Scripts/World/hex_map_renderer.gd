
extends Node2D
class_name HexMapRenderer

const HEX_SIZE: float = 32.0

var hex_map: HexMap
var selected_tile: Vector2i = Vector2i(-1, -1)

@onready var tile_info_label: Label = $"../TileInfoLabel"
@onready var new_map_button: Button = $"../NewMapButton"

func _ready() -> void:
	hex_map = HexMap.new()
	hex_map.generate_map(8, 6)
	new_map_button.pressed.connect(generate_new_map)
	queue_redraw()

func generate_new_map() -> void:
	hex_map.map_seed += 1
	hex_map.generate_map(8, 6)
	selected_tile = Vector2i(-1, -1)
	queue_redraw()

func _draw() -> void:
	if hex_map == null:
		return

	for tile in hex_map.tiles:
		var center: Vector2 = hex_to_pixel(tile)
		var points: PackedVector2Array = get_hex_points(center)

		var tile_color: Color = Color(0.35, 0.55, 0.32)
		match hex_map.terrain[tile]:
			HexMap.TerrainType.GRASS:
				tile_color = Color(0.35, 0.55, 0.32)
			HexMap.TerrainType.WATER:
				tile_color = Color(0.2, 0.45, 0.8)
			HexMap.TerrainType.MOUNTAIN:
				tile_color = Color(0.55, 0.55, 0.58)
		if tile == selected_tile:
			tile_color = Color(0.95, 0.8, 0.2)

		draw_colored_polygon(points, tile_color)

		var outline: PackedVector2Array = points.duplicate()
		outline.append(points[0])

		draw_polyline(
			outline,
			Color(0.12, 0.18, 0.12),
			2.0
		)


func hex_to_pixel(hex: Vector2i) -> Vector2:
	var x: float = HEX_SIZE * sqrt(3.0) * (
		hex.x + 0.5 * (hex.y % 2)
	)
	var y: float = HEX_SIZE * 1.5 * hex.y

	return Vector2(x + 50.0, y + 50.0)


func get_hex_points(center: Vector2) -> PackedVector2Array:
	var points: PackedVector2Array = PackedVector2Array()

	for i in range(6):
		var angle: float = deg_to_rad(60.0 * i - 30.0)
		points.append(
			center + Vector2(cos(angle), sin(angle)) * HEX_SIZE
		)

	return points


func pixel_to_hex(position: Vector2) -> Vector2i:
	var local_position: Vector2 = position - Vector2(50.0, 50.0)

	var approx_y: int = roundi(
		local_position.y / (HEX_SIZE * 1.5)
	)
	var approx_x: int = roundi(
		local_position.x / (HEX_SIZE * sqrt(3.0))
		- 0.5 * (approx_y % 2)
	)

	return Vector2i(approx_x, approx_y)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var mouse_position: Vector2 = get_global_mouse_position()
			var tile: Vector2i = pixel_to_hex(mouse_position)

			if hex_map.tiles.has(tile):
				selected_tile = tile
				print("Selected tile: ", selected_tile)
				tile_info_label.text = "Selected tile: " + str(tile)
				queue_redraw()
