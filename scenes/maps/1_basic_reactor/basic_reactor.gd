extends Node2D

var x_grid_range: int = 30
var y_grid_range: int = 15
var margin: int = 60

var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	GameRunner.game_mode_enabled = false
	get_parent().build_grid_and_center(x_grid_range, y_grid_range, true, true, false, true)
	GameRunner.goal = 200 # set this to let ctrl rods  autoamtic aim for something
	Atom.spont_emis_time = 3.0


	get_parent().get_node("Control").show()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Layer2").show()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Tree").show()
	get_parent().get_node("State").show()
	get_parent().get_node("GameScore").hide()
	
	
