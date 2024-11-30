extends Node2D

var x_grid_range: int = 70
var y_grid_range: int = 35
var margin: int = 25

var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")
var water_scene:PackedScene = load("res://scenes/fission_objects/water.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# set enrichment atom settings 
	Atom.keep_enriched = false
	Atom.enable_sponteniues_neutrons = false
	Atom.enrich_percent = 0.95
	
	# set atoms and controlRods
	for x in range(0,x_grid_range):
		for y in range(0, y_grid_range): 
			var new_atom:Node = atom_scene.instantiate()
			new_atom.initialize(Vector2(margin + margin*x, margin + margin*y), true) 
			add_child(new_atom) 
		
			var new_water:Node = water_scene.instantiate()
			new_water.initialize(Vector2(margin + margin*x, margin + margin*y)) 
			add_child(new_water) 
	
	var new_neutron:Node = neutron_scene.instantiate()
	new_neutron.initialize(Vector2(2000, 500), Vector2(-1, 0)) 
	add_child(new_neutron) 
	
	
func _on_timer_timeout() -> void:
	print(Engine.get_frames_per_second())
	
