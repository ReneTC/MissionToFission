extends Control

var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")

func _ready() -> void:
	$MarginContainer.position[1] = -932.5
	configure_settings()
	animate_in()
	
	$UiButtonSound.connect_button_ui()
	
	var margin:float = 65.
	for x in range(-1, 30):
		for y in range(-2, 17):
			if randf() > 0.90:
				var new_atom:Node = atom_scene.instantiate()
				new_atom.initialize(Vector2(margin + margin*x, margin + margin*y), randi_range(0, 1),) 
				add_child(new_atom) 

	# connect not implimented buttons
	var buttons_404: Array[Node] = get_tree().get_nodes_in_group("404")
	for button in buttons_404:
		button.pressed.connect(_on_404_pressed)
		
	# instantly load new map for debug
	animate_out("res://scenes/maps/3_lwr/lwr_simulate.tscn", "res://scenes/game_core/game_runner.tscn")

func configure_settings() -> void:
	globals.reset_game_var()
	Atom.enable_sponteniues_neutrons = true

func animate_in() -> void:
	configure_settings()
	Dialogic.end_timeline() # Prevents text boxes from showing when exiting tutorial
	$fly_in_sound.play()
	$SceneFader.fade_out()
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($MarginContainer, "position:y", 0, 0.8)
	

	
func animate_out(map_load:String, scene_file:String) -> void:
	$fly_in_sound.play()
	$SceneFader.fade_in()
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($Camera2D, "position:y", -1200, 0.8)
	tween.connect("finished", on_tween_finished.bind(map_load, scene_file))
	
	
func on_tween_finished(map_load:String, scene_file:String) -> void:
	globals.reset_game_var()
	GameRunner.map_to_load = map_load
	get_tree().change_scene_to_file(scene_file)
	
func _on_button_quit_pressed() -> void:
	get_tree().quit()

# bad code, select menu
func _on_button_sandbox_pressed() -> void:
	animate_out("res://scenes/maps/misc/sandbox.tscn", "res://scenes/game_core/game_runner.tscn")


func _on_button_credits_pressed() -> void:
	animate_out("res://scenes/maps/2_rmbk/rbmk_reactor.tscn", "res://addons/maaacks_credits_scene/examples/scenes/end_credits/end_credits.tscn")


func _on_button_pressed() -> void:
	animate_out("res://scenes/maps/1_basic_reactor/tutorial.tscn", "res://scenes/game_core/game_runner.tscn")

func _on_button_3_pressed() -> void:
	animate_out("res://scenes/maps/1_basic_reactor/basic_reactor.tscn", "res://scenes/game_core/game_runner.tscn")


func _on_404_pressed() -> void:
	animate_out("res://scenes/menus/404.tscn", "res://scenes/game_core/game_runner.tscn")

func _on_button_2_pressed() -> void:
	animate_out("res://scenes/maps/1_basic_reactor/basic_reactor_game.tscn", "res://scenes/game_core/game_runner.tscn")

# escape on exit
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_simulate_mode_rbmk_pressed() -> void:
	animate_out("res://scenes/maps/2_rbmk/rbmk_reactor.tscn", "res://scenes/game_core/game_runner.tscn")


func _on_tutorial_pressed() -> void:
	animate_out("res://scenes/maps/2_rbmk/tutorial.tscn", "res://scenes/game_core/game_runner.tscn")


func _on_game_mode_rbmk_pressed() -> void:
	animate_out("res://scenes/maps/2_rbmk/rbmk_reactor_game.tscn", "res://scenes/game_core/game_runner.tscn")


func _on_simulate_mode_lwr_pressed() -> void:
	animate_out("res://scenes/maps/3_lwr/lwr_simulate.tscn", "res://scenes/game_core/game_runner.tscn")
