extends Node2D

var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")
var water_scene:PackedScene = load("res://scenes/fission_objects/water.tscn")

var tut_state: String = "chap1"
var atoms: Array = []

var x_grid_range: int = 10
var y_grid_range: int = 6
var margin: int = 60

var game_runner_instant: Node = null


func _ready() -> void:
	
	# disable spawn click with mouse
	GameRunner.neutron_on_click = false
	$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, true)
	$Area2D.position = get_viewport_rect().size / 2
	# disable neutron counter 
	get_parent().goal = 100
	get_parent().margin_error = 20
	game_runner_instant = get_parent()
	game_runner_instant.game_mode_enabled = false
	get_parent().get_node("Control").hide()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Tree").hide()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Layer2").show()
	get_parent().get_node("State").hide()
	get_parent().get_node("GameScore").hide()
	
	Atom.enable_enrich = false
	Atom.instant_enrich_chance = 0.0
	Atom.enable_sponteniues_neutrons = false
	
	
	# start from start 
	# tut_state = "first_chain_reaction" # skip for debug DElete ME 
	Dialogic.start(tut_state)
	Dialogic.signal_event.connect(DialogicSignal)


func DialogicSignal(argument:String) -> void:
	if argument == "put_u_and_play":
		var new_atom:Node = atom_scene.instantiate()
		new_atom.initialize(get_viewport_rect().size / 2, true) 
		add_child(new_atom) 
		atoms.append(new_atom)
		Dialogic.start("chap2")
		
	elif argument == "play_neutron":
		tut_state = "play_neutron"
		var new_neutron:Node = neutron_scene.instantiate()
		new_neutron.initialize(get_viewport_rect().size / 2 - Vector2(300, 0), Vector2(1, 0)) 
		add_child(new_neutron) 
		
	elif argument == "you_try_split":
		tut_state = "you_try_split"
		GameRunner.neutron_on_click = true
		atoms[0].enrich()
		atoms[0].queue_redraw()
		$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, true)
	
	elif argument == "chap2Done":
		Dialogic.start("chap3")
	
	elif argument == "first_chain":
		# remove old atom
		for i in range(atoms.size() - 1, -1, -1):
			atoms[i].queue_free()
			atoms.remove_at(i)
			
		# TODO REMOVE NEUTRPNMS HERE 
		var neutrons = get_tree().get_nodes_in_group("neutrons")
		for neutron in neutrons:
			neutron.kill_self()
		
		# show state of reactor
		get_parent().get_node("MarginContainer").show()
		GameRunner.neutron_on_click = true
		tut_state = "first_chain_reaction"
		$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, true)    
		$Area2D/CollisionShape2D2.shape.radius = 1000
		# make grid
		Atom.enable_sponteniues_neutrons = false 
		game_runner_instant.build_grid_and_center(2 * x_grid_range, 2 * y_grid_range, true, false, true)

				
	elif argument == "chap4":
		Dialogic.start("chap4")
	
	elif argument == "add_control_rods":
		
		for x in range(0, 2 * x_grid_range):
			if x % 3 == 0:
				var new_controlRod:Node = controlRod_scene.instantiate()
				new_controlRod.initialize(Vector2(margin + margin*x +0.5*margin, 0)) 
				add_child(new_controlRod)
				
	elif argument == "more_control":
		Atom.enable_sponteniues_neutrons = true
		Atom.spont_emis_time = 1.0
		Atom.enable_enrich = true
		Atom.enrich_speed = 0.5
		ControlRod.enable_auomatic = false
		game_runner_instant._on_check_box_enrich_toggled(true)
		# get_parent().get_node("Control").show()
		get_parent().get_node("State").show()
		tut_state = "more_control2"
		
	elif argument == "final_game":
		GameRunner.game_mode_enabled = true
		GameRunner.goal = 100
		GameRunner.margin_error = 50
		# get_parent().get_node("Control").show()
		# get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Layer2").hide()
		# get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Tree").hide()
		get_parent().get_node("State").show()
		get_parent().get_node("GameScore").show()
		tut_state = "final_game2"
		
# neutron collide with urnium atom center
func _on_area_2d_body_entered(_body: Node2D) -> void:
	if tut_state == "play_neutron":
		# disable more neutrons checks 
		$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, false)
		Dialogic.start("chap2", "neutron_hit")
		
	elif tut_state == "you_try_split":
		$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, false)
		Dialogic.start("chap2", "manual_neutron")
		GameRunner.neutron_on_click = false
	
	elif tut_state == "first_chain_reaction":
		if Atom.enriched_present == 0:
			# $Area2D.set_collision_mask_value(globals.neutrol_collide_slot, false)
			$Timer.start()
			
			
	elif tut_state == "more_control":
		get_parent().get_node("State").show()
		get_parent().get_node("Control").show()
		$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, true)
		tut_state = "more_control2"
	
	elif tut_state == "more_control2" and len(get_tree().get_nodes_in_group("neutrons")) > 49:
		Dialogic.start("chap4", "sucess50")
		tut_state = "tut_done"
		
	elif tut_state == "final_game2" and GameRunner.score_timer > 60:
		tut_state = "final_game3"
		Dialogic.start("chap4", "sucessFINAL")
	
# timout call such that 3 calls wont happen
func _on_timer_timeout() -> void:
	if tut_state == "first_chain_reaction":
		tut_state = "more_control2"
		Dialogic.start("chap3", "chain_complete")

	
