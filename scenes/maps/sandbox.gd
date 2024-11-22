extends Control
# this is a playroom for debugging. enable spawn of Atoms, neutrons, control rods
# and all upcommign objects for testing. 
var neutron_scene = load("res://scenes/fission_objects/neutron.tscn")
var atom_scene = load("res://scenes/fission_objects/atom.tscn")
var controlRod_scene = load("res://scenes/fission_objects/controlRod.tscn")
var water_scene = load("res://scenes/fission_objects/water.tscn")
var moderator_scene = load("res://scenes/fission_objects/moderator.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# start debug 
	DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED
	
	# place objects 
	var new_atom = atom_scene.instantiate()
	new_atom.initialize(Vector2(200, 200), true) 
	add_child(new_atom) 

	var new_controlRod = controlRod_scene.instantiate()
	new_controlRod.initialize(Vector2(50, 50)) 
	add_child(new_controlRod) 
	
	var new_moderator = moderator_scene.instantiate()
	new_moderator.initialize(Vector2(600, 50)) 
	add_child(new_moderator) 

	var new_water = water_scene.instantiate()
	new_water.initialize(Vector2(400, 400)) 
	add_child(new_water) 



func _input(event) -> void:

	# click to put objects (test only)	
	if event is InputEventMouseButton and not event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var new_neutron = neutron_scene.instantiate()
				new_neutron.initialize(event.position) 
				add_child(new_neutron) 
			MOUSE_BUTTON_RIGHT:
				var new_atom = atom_scene.instantiate()
				new_atom.initialize(event.position, true) 
				add_child(new_atom) 
			MOUSE_BUTTON_MIDDLE:
				var new_controlRod = controlRod_scene.instantiate()
				new_controlRod.initialize(event.position) 
				add_child(new_controlRod) 
				
func _process(delta: float) -> void:
	$Label.text = str(Neutron.neutrons_present)
