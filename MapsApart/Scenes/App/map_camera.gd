
extends Camera2D

@export var min_zoom: float = 0.4
@export var max_zoom: float = 2.5
@export var zoom_sensitivity: float = 1.0
@export var pan_sensitivity: float = 1.0

var is_panning: bool = false


func _unhandled_input(event: InputEvent) -> void:
	# Touchpad pinch, when the device sends a magnify gesture.
	if event is InputEventMagnifyGesture:
		set_zoom_level(zoom.x / pow(event.factor, zoom_sensitivity))
		get_viewport().set_input_as_handled()

	# Two-finger touchpad pan, when the device sends a pan gesture.
	elif event is InputEventPanGesture:
		position -= event.delta * pan_sensitivity / zoom.x
		get_viewport().set_input_as_handled()

	# Right-click or middle-click and drag to move around the map.
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT \
		or event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
			get_viewport().set_input_as_handled()

		# Mouse-wheel zoom as a fallback.
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			set_zoom_level(zoom.x * 1.1)
			get_viewport().set_input_as_handled()

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			set_zoom_level(zoom.x / 1.1)
			get_viewport().set_input_as_handled()

	elif event is InputEventMouseMotion and is_panning:
		position -= event.relative * pan_sensitivity / zoom.x
		get_viewport().set_input_as_handled()



func set_zoom_level(value: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var new_zoom: float = clamp(value, min_zoom, max_zoom)

	zoom = Vector2(new_zoom, new_zoom)

	var new_mouse_position: Vector2 = get_global_mouse_position()
	position += mouse_position - new_mouse_position
