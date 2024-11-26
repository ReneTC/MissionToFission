extends Control

var gameRunner:PackedScene = load("res://scenes/menus/game_runner.tscn")

func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_sandbox_pressed() -> void:
	GameRunner.map_to_load = "res://scenes/maps/sandbox.tscn" 
	get_tree().change_scene_to_file("res://scenes/menus/game_runner.tscn")


func _on_button_basic_reactor_pressed() -> void:
	GameRunner.map_to_load = "res://scenes/maps/basic_reactor.tscn" 
	get_tree().change_scene_to_file("res://scenes/menus/game_runner.tscn")

func _on_button_rbmk_reactor_pressed() -> void:
	GameRunner.map_to_load = "res://scenes/maps/rbmk_reactor.tscn" 
	get_tree().change_scene_to_file("res://scenes/menus/game_runner.tscn")


func _on_button_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://addons/maaacks_credits_scene/examples/scenes/end_credits/end_credits.tscn")
