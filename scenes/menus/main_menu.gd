extends Control

func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_sandbox_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/sandbox.tscn")


func _on_button_basic_reactor_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/basic_reactor.tscn")


func _on_button_rbmk_reactor_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/rbmk_reactor.tscn")


func _on_button_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://addons/maaacks_credits_scene/examples/scenes/end_credits/end_credits.tscn")
