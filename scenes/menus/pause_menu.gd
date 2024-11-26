extends Control

@export var game_runner: GameRunner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	game_runner.connect("toggle_game_paused", _on_game_runner_toggle_game_paused)


func _on_game_runner_toggle_game_paused(is_paused:bool) -> void:
	if is_paused:
		show()
	else:
		hide()


func _on_continue_pressed() -> void:
	game_runner.game_paused = false	


func _on_main_pressed() -> void:
	game_runner.game_paused = false	
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	

func _on_exit_pressed() -> void:
	get_tree().quit()
