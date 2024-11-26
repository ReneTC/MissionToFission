extends Control

var gameRunner:PackedScene = load("res://scenes/menus/game_runner.tscn")
var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")

func _ready() -> void:

	for x in range(0, 30):
		var new_atom:Node = atom_scene.instantiate()
		new_atom.initialize(Vector2(DisplayServer.screen_get_size()[0] * randf(), DisplayServer.screen_get_size()[1] * randf()), randi_range(0, 1),) 
		add_child(new_atom) 
		
			
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
