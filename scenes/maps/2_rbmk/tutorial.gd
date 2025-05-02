extends Node2D

var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")
var water_scene:PackedScene = load("res://scenes/fission_objects/water.tscn")

var tut_state: String = "chap5_water"
var atoms: Array = []

var x_grid_range: int = 14
var y_grid_range: int = 10
var margin: int = 60

var game_runner_instant: Node = null


func _ready() -> void:
	
	# disable spawn click with mouse
	$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, true)
	$Area2D.position = get_viewport_rect().size / 2
	# disable neutron counter 
	get_parent().goal = 100
	get_parent().margin_error = 20
	game_runner_instant = get_parent()
	game_runner_instant.game_mode_enabled = false
	GameRunner.goal = 40
	get_parent().get_node("Control").hide()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Tree").hide()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Layer2").show()
	get_parent().get_node("State").hide()
	get_parent().get_node("GameScore").hide()
	
	Atom.enable_enrich = true
	Atom.instant_enrich_chance = 0.0
	Atom.enable_sponteniues_neutrons = false
	get_parent().build_grid_and_center(x_grid_range, y_grid_range, true, true, false, true, 4)
	# start from start 
	# tut_state = "first_chain_reaction" # skip for debug DElete ME 
	Dialogic.start(tut_state)
	Dialogic.signal_event.connect(DialogicSignal)


func DialogicSignal(argument:String) -> void:
	if argument == "add_water":
		get_parent().build_grid_and_center(x_grid_range, y_grid_range, false, false, false, true, 4, false, true, true)
	
	if argument == "add_xenon":
		Atom.enable_xenon = true

	if argument == "add_fast":
		Neutron.enable_moderation = true

	if argument == "add_moderation":
		get_parent().build_grid_and_center(x_grid_range, y_grid_range, false, false, false, true, 4, true, false, true)
