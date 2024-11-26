extends Node

class_name GameRunner

static var map_to_load: String = "res://scenes/maps/basic_reactor.tscn"

signal toggle_game_paused(is_paused: bool)
var game_paused: bool = false:
	get:
		return game_paused
	set(value): 
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)
		
func _input(event:InputEvent) -> void:
	# close program on esc button
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused
		

# load map on ready
func _ready() -> void:
	
	# Load the scene
	var scene = load( self.map_to_load)
	
	# Instantiate the scene
	var instance_current = scene.instantiate()

	# Add the instance to the current scene
	add_child(instance_current)
