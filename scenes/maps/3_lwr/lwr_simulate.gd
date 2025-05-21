extends Node2D
# grid settings
var x_grid_range: int = 30
var y_grid_range: int = 15
var margin: int = 60


func _ready() -> void:
	globals.reset_game_var()
	# set map settings 
	# Atom.enrich_percent = 0.5
	Atom.enable_moderation = true
	Atom.enable_xenon = true
	Neutron.enable_moderation = true
	GameRunner.game_mode_enabled = false
	GameRunner.goal = 200 # set this to let ctrl rods  autoamtic aim for something

	
	get_parent().get_node("Control").show()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Layer2").show()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Tree").show()
	get_parent().get_node("State").show()
	get_parent().get_node("GameScore").hide()


	get_parent().build_grid_and_center(x_grid_range, y_grid_range, true, true, false, true, 3, false, true)
