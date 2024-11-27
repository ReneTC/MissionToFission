extends Node

func connect_button_ui() -> void:
	var buttons: Array = get_tree().get_nodes_in_group("button_ui")
	for button in buttons:
		button.mouse_entered.connect(mouse_entered.bind(button))
		button.mouse_exited.connect(mouse_exited.bind(button))
		button.pressed.connect(mouse_cliked)

func mouse_entered(_button) -> void:
	$hover_sound.play()
	# var tween = get_tree().create_tween()
	# tween.tween_property(button, "rect_min_size", 100, 0.1)
func mouse_cliked()->void:
		$click.play()
	
func mouse_exited(_button) -> void:
	pass
	# $hover_sound.play()
	# var tween2 = get_tree().create_tween()
	# tween2.tween_property(button, "size", Vector2(0.9,0.9,), 0.1)
