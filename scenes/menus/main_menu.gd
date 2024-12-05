extends Control

var gameRunner:PackedScene = load("res://scenes/menus/game_runner.tscn")
var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")

func _ready() -> void:
	$MarginContainer.position[1] = -932.5
	globals.reset_game_var()
	animate_in()
	
	$UiButtonSound.connect_button_ui()
	
	for x in range(0, 30):
		var new_atom:Node = atom_scene.instantiate()
		new_atom.initialize(Vector2(DisplayServer.screen_get_size()[0] * randf(), DisplayServer.screen_get_size()[1] * randf()), randi_range(0, 1),) 
		add_child(new_atom) 
	
	
	
func animate_in() -> void:
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
	animate_out("res://scenes/maps/sandbox.tscn", "res://scenes/menus/game_runner.tscn")

func _on_button_basic_reactor_pressed() -> void:
	animate_out("res://scenes/maps/basic_reactor.tscn", "res://scenes/menus/game_runner.tscn")

func _on_button_rbmk_reactor_pressed() -> void:
	animate_out("res://scenes/maps/rbmk_reactor.tscn", "res://scenes/menus/game_runner.tscn")

func _on_button_credits_pressed() -> void:
	animate_out("res://scenes/maps/rbmk_reactor.tscn", "res://addons/maaacks_credits_scene/examples/scenes/end_credits/end_credits.tscn")


func _on_button_performances_pressed() -> void:
	animate_out("res://scenes/maps/performance_test.tscn", "res://scenes/menus/game_runner.tscn")


func _on_button_tutorial_pressed() -> void:
	animate_out("res://scenes/maps/tutorial.tscn", "res://scenes/menus/game_runner.tscn")

# escape on exit
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.is_action_pressed("ui_cancel"):
		get_tree().quit()
