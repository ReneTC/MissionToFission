extends Node2D

var x_grid_range = 30
var y_grid_range = 15
var margin = 60

var atom_scene = load("res://scenes/atom.tscn")
var neutron_scene = load("res://scenes/neutron.tscn")
var controlRod_scene = load("res://scenes/controlRod.tscn")

# add atom grid
# add control rod 
# make atom enrich over time
# enable control rof control rods 
# delete atom when fly out
# neutron counter 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set atoms 
	for x in range(0,x_grid_range):
		for y in range(0, y_grid_range): 
			var new_atom = atom_scene.instantiate()
			new_atom.initialize(Vector2(margin + margin*x, margin + margin*y), true) 
			add_child(new_atom) 
			
		if x % 3 == 0:
			var new_controlRod = controlRod_scene.instantiate()
			new_controlRod.initialize(Vector2(margin + margin*x +0.5*margin, 0)) 
			add_child(new_controlRod) 
			
	# set control rods 

	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
