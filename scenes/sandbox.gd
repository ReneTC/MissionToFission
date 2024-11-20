extends Control
# this is a playroom for debugging. enable spawn of Atoms, neutrons, control rods
# and all upcommign objects for testing. 
var neutron_scene = load("res://scenes/neutron.tscn")
var atom_scene = load("res://scenes/atom.tscn")
var controlRod_scene = load("res://scenes/controlRod.tscn")


var spawn_object = "Neutron"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# start debug 
	DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED


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
			MOUSE_BUTTON_XBUTTON1:
				var new_controlRod = controlRod_scene.instantiate()
				new_controlRod.initialize(event.position) 
				add_child(new_controlRod) 
			
