extends Node2D

var x_grid_range: int = 30
var y_grid_range: int = 15
var margin: int = 60

var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_node("Control").show()
	get_parent().get_node("State").show()
	# set enrichment atom settings 
	Atom.keep_enriched = false
	# Atom.enable_sponteniues_neutrons = false
	# Atom.enrich_percent = 0.95
	
	# set atoms and controlRods
	for x in range(0,x_grid_range):
		for y in range(0, y_grid_range): 
			var new_atom:Node = atom_scene.instantiate()
			new_atom.initialize(Vector2(margin + margin*x, margin + margin*y), true) 
			add_child(new_atom) 

		if x % 3 == 0:
			var new_controlRod:Node = controlRod_scene.instantiate()
			new_controlRod.initialize(Vector2(margin + margin*x +0.5*margin, 0)) 
			add_child(new_controlRod) 
