extends Control

@export var game_runner: GameRunner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	game_runner.connect("toggle_game_paused", _on_game_runner_toggle_game_paused)
	hide()
	# add sounds to button
	$UiButtonSound.connect_button_ui()

func _on_game_runner_toggle_game_paused(is_paused:bool) -> void:
	if is_paused:
		show()
		animate_in()
		
	else:
		hide()
		animate_out()

func animate_in() -> void:
	$fly_in_sound.play()
	$".".position[1] = 450
	# why the f does this not work
	#var tween = get_tree().create_tween()
	#tween.set_ease(Tween.EaseType.EASE_OUT)
	#tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	# tween.tween_property($".", "position:y", 200, 0.8)
	
func animate_out() -> void:
	$fly_in_sound.play()
	$".".position[1] = 450
	# var tween1 = get_tree().create_tween()
	# tween1.set_ease(Tween.EaseType.EASE_OUT)
	#tween1.set_trans(Tween.TransitionType.TRANS_CUBIC)
	#tween1.tween_property($".", "position:y", -60, 0.8)
	
func _on_continue_pressed() -> void:
	game_runner.game_paused = false	


func _on_main_pressed() -> void:
	game_runner.game_paused = false	
	var tween2:Tween = get_tree().create_tween()
	tween2.set_ease(Tween.EaseType.EASE_OUT)
	tween2.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween2.tween_property(game_runner.map_loaded, "position:y", 1000, 0.8)
	tween2.connect("finished", new_map)

func new_map() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	

func _on_exit_pressed() -> void:
	get_tree().quit()
