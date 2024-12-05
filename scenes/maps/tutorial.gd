extends Node2D

var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")
var water_scene:PackedScene = load("res://scenes/fission_objects/water.tscn")

var tut_state: String = " "
var atoms = []

func _ready() -> void:
	# disable spawn click with mouse
	GameRunner.neutron_on_click = false
	$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, true)
	$Area2D.position = get_viewport_rect().size / 2
	# disable neutron counter 
	get_parent().get_node("MarginContainer").hide()
	
	tut_state = "chap1"
	Dialogic.start("chap1")
	Dialogic.signal_event.connect(DialogicSignal)
	
	# skip some start tut
	# DialogicSignal("put_u_and_play")

func DialogicSignal(argument:String) -> void:
	if argument == "put_u_and_play":
		var new_atom:Node = atom_scene.instantiate()
		new_atom.initialize(get_viewport_rect().size / 2, true) 
		add_child(new_atom) 
		atoms.append(new_atom)
		Dialogic.start("chap2")
		
	if argument == "play_neutron":
		tut_state = "play_neutron"
		var new_neutron:Node = neutron_scene.instantiate()
		new_neutron.initialize(get_viewport_rect().size / 2 - Vector2(100, 0), Vector2(1, 0)) 
		add_child(new_neutron) 
		
	if argument == "you_try_split":
		$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, true)
		tut_state = "you_try_split"
		GameRunner.neutron_on_click = true
		atoms[0].is_enriched = true 
		atoms[0].queue_redraw()
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if tut_state == "play_neutron":
		# disable more neutrons checks 
		$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, false)
		Dialogic.start("chap2", "neutron_hit")
		
	if tut_state == "you_try_split":
		
		$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, false)
