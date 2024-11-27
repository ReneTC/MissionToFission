extends Control
# this is a playroom for debugging. enable spawn of Atoms, neutrons, control rods
# and all upcommign objects for testing. 
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")
var water_scene:PackedScene = load("res://scenes/fission_objects/water.tscn")
var moderator_scene:PackedScene = load("res://scenes/fission_objects/moderator.tscn")

var click_object:PackedScene = neutron_scene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# start debug 
	DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED

	GameRunner.neutron_on_click = false

func _on_gui_input(event: InputEvent) -> void:
	# click to put objects (test only)	
	if event is InputEventMouseButton and not event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var new_obj = click_object.instantiate()
				new_obj.initialize(event.position) 
				add_child(new_obj) 


func _on_check_button_2_toggled(_toggled_on: bool) -> void:
	click_object = atom_scene

func _on_check_button_3_toggled(_toggled_on: bool) -> void:
	click_object = controlRod_scene


func _on_check_button_4_toggled(_toggled_on: bool) -> void:
	click_object = water_scene

func _on_check_button_5_toggled(_toggled_on: bool) -> void:
	click_object = neutron_scene
