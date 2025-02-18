extends HScrollBar

@export var accepted_range: Vector2: set = set_accepted_range
@export var current_value: float: set = set_current_value


func set_accepted_range(new_range: Vector2) -> void:
	accepted_range = new_range.clampf(min_value, max_value)
	value = accepted_range.x
	page = accepted_range.y - accepted_range.x
	set_current_value(current_value)


func set_current_value(new_value: float) -> void:
	current_value = clampf(new_value, accepted_range.x, accepted_range.y)
	queue_redraw()


func _draw() -> void:
	var marker_min_pos: Vector2 = position + Vector2(accepted_range.x / max_value * size.x, 4.0)
	var marker_max_pos: Vector2 = position + Vector2(accepted_range.y / max_value * size.x, 4.0)
	var marker_curr_pos: Vector2 = position + Vector2(current_value / max_value * size.x, 4.0)

	const offset := Vector2(-7.0, 4.5)
	draw_circle(marker_min_pos, 10.0, Color.WHITE)
	draw_string(ThemeDB.fallback_font, marker_min_pos + offset, str(accepted_range.x), 0, -1, 12, Color.BLACK)
	draw_circle(marker_max_pos, 10.0, Color.WHITE)
	draw_string(ThemeDB.fallback_font, marker_max_pos + offset, str(accepted_range.y), 0, -1, 12, Color.BLACK)
	const marker_size := Vector2(30.0, 20.0)
	const marker_offset := Vector2(0.0, -18.0)
	draw_rect(Rect2(marker_curr_pos - marker_size/2.0 + marker_offset, marker_size), Color.WHITE)
	draw_circle(marker_curr_pos + Vector2.UP * 8.0, 4.0, Color.WHITE)
	draw_string(ThemeDB.fallback_font, marker_curr_pos + offset + Vector2.UP * (-marker_offset.y), str(current_value), 0, -1, 12, Color.BLACK)
