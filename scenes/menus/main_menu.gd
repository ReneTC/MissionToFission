extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_sandbox_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sandbox.tscn")


func _on_button_basic_reactor_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/basic_reactor.tscn")
