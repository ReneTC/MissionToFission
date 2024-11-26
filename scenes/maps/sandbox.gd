extends Control
# this is a playroom for debugging. enable spawn of Atoms, neutrons, control rods
# and all upcommign objects for testing. 
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")
var water_scene:PackedScene = load("res://scenes/fission_objects/water.tscn")
var moderator_scene:PackedScene = load("res://scenes/fission_objects/moderator.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# start debug 
	DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED
	


func _input(event: InputEvent) -> void:

	# click to put objects (test only)	
	if event is InputEventMouseButton and not event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var new_neutron:Node = neutron_scene.instantiate()
				new_neutron.initialize(event.position) 
				add_child(new_neutron) 
			MOUSE_BUTTON_RIGHT:
				var new_atom:Node = atom_scene.instantiate()
				new_atom.initialize(event.position, true) 
				add_child(new_atom) 
			MOUSE_BUTTON_MIDDLE:
				var new_controlRod:Node = controlRod_scene.instantiate()
				new_controlRod.initialize(event.position) 
				add_child(new_controlRod) 
				
func _process(_delta: float) -> void:
	$Label.text = str(Neutron.neutrons_present)
