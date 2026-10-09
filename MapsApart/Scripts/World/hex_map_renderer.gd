
extends Node2D
class_name HexMapRenderer

const HEX_SIZE: float = 32.0

var hex_map: HexMap


func _ready() -> void:
	hex_map = HexMap.new()
	hex_map.generate_map(8, 6)
	queue_redraw()



func _draw() -> void:
	if hex_map == null:
		return

	for tile in hex_map.tiles:
		var center := hex_to_pixel(tile)
		var points := get_hex_points(center)

		draw_colored_polygon(
			points,
			Color(0.35, 0.55, 0.32)
		)

		var outline := points.duplicate()
		outline.append(points[0])

		draw_polyline(
			outline,
			Color(0.12, 0.18, 0.12),
			2.0
		)



func hex_to_pixel(hex: Vector2i) -> Vector2:
	var x := HEX_SIZE * sqrt(3.0) * (hex.x + 0.5 * (hex.y % 2))
	var y := HEX_SIZE * 1.5 * hex.y
	return Vector2(x + 50.0, y + 50.0)


func get_hex_points(center: Vector2) -> PackedVector2Array:
	var points := PackedVector2Array()

	for i in range(6):
		var angle := deg_to_rad(60.0 * i - 30.0)
		points.append(
			center + Vector2(cos(angle), sin(angle)) * HEX_SIZE
		)

	return points
