extends Node2D

# grid settings
var x_grid_range: int = 30
var y_grid_range: int = 15
var margin: int = 60

# get fission objects
var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")
var water_scene:PackedScene = load("res://scenes/fission_objects/water.tscn")
var moderator_scene:PackedScene = load("res://scenes/fission_objects/moderator.tscn")


func _ready() -> void:
	# set map settings 
	Atom.keep_enriched = true
	Atom.enrich_percent = 0.5
	Atom.enable_moderation = true
	Neutron.enable_moderation = true

	# set atoms and controlRods
	for x in range(0,x_grid_range):
		x *= margin
		
		# set control rods
		if x % 40 == 0:
			var new_controlRod:Node = controlRod_scene.instantiate()
			new_controlRod.initialize(Vector2(margin + x +0.5*margin, 0)) 
			add_child(new_controlRod) 

		# set moderators
		if x % 40 == 20:
			var new_moderator:Node = moderator_scene.instantiate()
			new_moderator.initialize(Vector2(margin + x +0.5*margin, 470)) 
			add_child(new_moderator)
	
		for y in range(0, y_grid_range): 
			y*=margin
			
			var new_water:Node = water_scene.instantiate()
			new_water.initialize(Vector2(margin + x, margin + y)) 
			add_child(new_water) 
			
			var new_atom:Node = atom_scene.instantiate()
			new_atom.initialize(Vector2(margin + x, margin + y), true) 
			add_child(new_atom) 
			
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label.text = str(Neutron.neutrons_present)
	
	$Label2.text = str(Atom.enriched_present)
	$Label3.text = str(Atom.unenriched_present)
	
func _input(event:InputEvent) -> void:

	# click to put objects (test only)	
	if event is InputEventMouseButton and not event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var new_neutron:Node = neutron_scene.instantiate()
				new_neutron.initialize(event.position) 
				add_child(new_neutron) 
