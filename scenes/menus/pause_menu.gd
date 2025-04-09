extends CanvasLayer

@export var game_runner: GameRunner
var can_pause:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_runner.connect("toggle_game_paused", _on_game_runner_toggle_game_paused)
	hide()
	# add sounds to button
	$UiButtonSound.connect_button_ui()
	
	# listen for upgrade buttons 
	for button in $Panel/upgradeMenu/upgradeContainer.get_children():
		if button is Button:
			button.pressed.connect(_on_button_pressed.bind(button))

func _on_game_runner_toggle_game_paused(is_paused:bool) -> void:
	if is_paused:
		show()
		animate_in()
		
	else:
		hide()
		animate_out()

func animate_in() -> void:
	$fly_in_sound.play()

	
func animate_out() -> void:
	$fly_in_sound.play()

	
func _on_continue_pressed() -> void:
	game_runner.game_paused = false	


func _on_main_pressed() -> void:
	globals.reset_game_var()
	game_runner.game_paused = false	
	var tween2:Tween = get_tree().create_tween()
	tween2.set_ease(Tween.EaseType.EASE_OUT)
	tween2.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween2.tween_property(game_runner.map_loaded.get_node("../Camera2D"), "offset:y", -1000, 0.8)
	$SceneFader.fade_in()
	tween2.connect("finished", new_map)
	

func new_map() -> void:
	globals.reset_game_var()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()

func upgrade_game_mode(random_keys:Array, upgrade_dict:Dictionary) -> void:
	# lock such that user dont esc pause 
	can_pause = false

	# generate 2 options
	$Panel/upgradeMenu/upgradeContainer/Opt1.text = random_keys[0]
	$Panel/upgradeMenu/upgradeContainer/Opt2.text = random_keys[1]
	
	$Panel/upgradeMenu/upgradeContainer/Opt1.tooltip_text = upgrade_dict[random_keys[0]][1]
	$Panel/upgradeMenu/upgradeContainer/Opt2.tooltip_text = upgrade_dict[random_keys[1]][1]
	
	# show correct menu
	$Panel/pauseMenu.hide()
	$Panel/upgradeMenu.show()
	
func _on_button_pressed(button: Button) -> void:
	# unlock pause lock
	can_pause = true
	
	# convert to normal pause box
	$Panel/pauseMenu.show()
	$Panel/upgradeMenu.hide()
	

	# return choice of upgrade
	game_runner.game_paused = false
	game_runner.call_upgrade(button.text)
	
func game_over_display(score:float) -> void:
	can_pause = false
	
	# show correct menu
	$Panel/pauseMenu.hide()
	$Panel/gameoverMenu.show()
	$Panel/gameoverMenu/score.text = "Your score is: %.1f" % score
