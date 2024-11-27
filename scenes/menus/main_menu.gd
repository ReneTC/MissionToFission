extends Control

var gameRunner:PackedScene = load("res://scenes/menus/game_runner.tscn")
var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")

func _ready() -> void:
	
	animate_in()
	
	$UiButtonSound.connect_button_ui()
	
	for x in range(0, 30):
		var new_atom:Node = atom_scene.instantiate()
		new_atom.initialize(Vector2(DisplayServer.screen_get_size()[0] * randf(), DisplayServer.screen_get_size()[1] * randf()), randi_range(0, 1),) 
		add_child(new_atom) 
	
	# add sounds to button

	
	
	# animate in
func animate_in() -> void:
	$fly_in_sound.play()
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($MarginContainer, "position:y", 0, 0.8)
	
func animate_out(map_load, scene_file) -> void:
	$fly_in_sound.play()
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($".", "position:y", -1200, 0.8)
	tween.connect("finished", on_tween_finished.bind(map_load, scene_file))
			
func on_tween_finished(map_load, scene_file):
	GameRunner.map_to_load = map_load
	get_tree().change_scene_to_file(scene_file)
	
func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_sandbox_pressed() -> void:
	animate_out("res://scenes/maps/sandbox.tscn", "res://scenes/menus/game_runner.tscn")



func _on_button_basic_reactor_pressed() -> void:
	animate_out("res://scenes/maps/basic_reactor.tscn", "res://scenes/menus/game_runner.tscn")

func _on_button_rbmk_reactor_pressed() -> void:
	animate_out("res://scenes/maps/rbmk_reactor.tscn", "res://scenes/menus/game_runner.tscn")


func _on_button_credits_pressed() -> void:
	animate_out("res://scenes/maps/rbmk_reactor.tscn", "res://addons/maaacks_credits_scene/examples/scenes/end_credits/end_credits.tscn")
