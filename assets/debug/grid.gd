extends Node2D

const GRID_STEP = 100
const GRID_SIZE = 20


func _draw() -> void:
	var default_font = ThemeDB.fallback_font
	var default_font_size = ThemeDB.fallback_font_size

	for i in range(GRID_SIZE):
		var col = Color("#000000")
		var width = 1.0
		if i == GRID_SIZE / 2:
			col = Color("#66cc66")
			width = 2.0
		draw_line(Vector2(i * GRID_STEP, 0), Vector2(i * GRID_STEP, GRID_SIZE * GRID_STEP), col, width)
		draw_string(default_font, Vector2(i * GRID_STEP, 0), str(i * GRID_STEP), HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size, "#000000")

	for j in range(GRID_SIZE):
		var col = Color("#000000")
		var width = 1.0
		if j == GRID_SIZE / 2:
			col = Color("#cc6666")
			width = 2.0
		draw_line(Vector2(0, j * GRID_STEP), Vector2(GRID_SIZE * GRID_STEP, j * GRID_STEP), col, width)
		draw_string(default_font, Vector2(0, j * GRID_STEP), str(j * GRID_STEP), HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size, "#000000")
