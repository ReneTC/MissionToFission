extends Node

func connect_button_ui() -> void:
	var buttons: Array = get_tree().get_nodes_in_group("button_ui")
	for button:Node in buttons:
		button.mouse_entered.connect(mouse_entered.bind(button))
		button.pressed.connect(mouse_cliked)

func mouse_entered(_button:Node) -> void:
	$hover_sound.play()
	# var tween = get_tree().create_tween()
	# tween.tween_property(button, "rect_min_size", 100, 0.1)
func mouse_cliked()->void:
		$click.play()
