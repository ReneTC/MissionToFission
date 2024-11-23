extends Node2D

var x_grid_range: int = 30
var y_grid_range: int = 15
var margin: int = 60

var atom_scene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene = load("res://scenes/fission_objects/neutron.tscn")
var controlRod_scene = load("res://scenes/fission_objects/controlRod.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set atoms and controlRods
	for x in range(0,x_grid_range):
		for y in range(0, y_grid_range): 
			var new_atom = atom_scene.instantiate()
			new_atom.initialize(Vector2(margin + margin*x, margin + margin*y), true) 
			add_child(new_atom) 
		
		if x % 3 == 0:
			var new_controlRod = controlRod_scene.instantiate()
			new_controlRod.initialize(Vector2(margin + margin*x +0.5*margin, 0)) 
			add_child(new_controlRod) 
			
	
	# set enrichment atom settings 
	Atom.keep_enriched = true
	Atom.enrich_percent = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label.text = str(Neutron.neutrons_present)
	
	$Label2.text = str(Atom.enriched_present)
	$Label3.text = str(Atom.unenriched_present)
	
func _input(event) -> void:

	# click to put objects (test only)	
	if event is InputEventMouseButton and not event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var new_neutron = neutron_scene.instantiate()
				new_neutron.initialize(event.position) 
				add_child(new_neutron) 
