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


func _ready() -> void:
	# disable spawn click with mouse
	GameRunner.neutron_on_click = false
	$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, true)
	$Area2D.position = get_viewport_rect().size / 2
	# disable neutron counter 
	get_parent().get_node("MarginContainer").hide()
	
	# start from start 
	# tut_state = "chap3" # skip for debug DElete ME 
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

		# show state of reactor
		get_parent().get_node("MarginContainer").show()
		GameRunner.neutron_on_click = true
		tut_state = "first_chain_reaction"
		$Area2D/CollisionShape2D2.shape.radius = 1000
		# make grid 

		for x in range(-x_grid_range ,x_grid_range):
			for y in range(-y_grid_range, y_grid_range): 
				var new_atom:Node = atom_scene.instantiate()
				new_atom.initialize(get_viewport_rect().size / 2.0 - Vector2(
					float(margin)/2.0 + margin*x,
					float(margin)/2.0 + margin*y)
				, true) 
				add_child(new_atom) 
				
	elif argument == "chap4":
		Dialogic.start("chap4")
	
	elif argument == "add_control_rods":
		for x in range(-x_grid_range,x_grid_range):	
			if x % 3 == 0:
				var new_controlRod:Node = controlRod_scene.instantiate()
				new_controlRod.initialize(get_viewport_rect().size / 2.0 - Vector2(
					margin/2.0 + margin*x +0.5*margin - margin, 0)) 
				add_child(new_controlRod) 
				
			
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
			$Area2D.set_collision_mask_value(globals.neutrol_collide_slot, false)
			$Timer.start()
	

# timout call such that 3 calls wont happen
func _on_timer_timeout() -> void:
	if tut_state == "first_chain_reaction":
		Dialogic.start("chap3", "chain_complete")
