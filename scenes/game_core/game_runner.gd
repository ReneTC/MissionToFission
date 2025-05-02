extends Node

class_name GameRunner

static var map_to_load: String = "res://scenes/maps/basic_reactor.tscn"
static var map_loaded:Node = null
static var neutron_on_click: bool = true


# get fission objects
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")
var moderator_scene:PackedScene = load("res://scenes/fission_objects/moderator.tscn")
var water_scene:PackedScene = load("res://scenes/fission_objects/water.tscn")

signal toggle_game_paused(is_paused: bool)

# keep track on what grid has been build
static var x_row_build:int = 0 
static var y_row_build:int = 0 
static var margin: float = 60.

# game settings
static var game_mode_enabled: bool = false
static var game_not_started: bool = true
static var goal:int = 400
static var margin_error:int = 100
static var neutron_counter: int = 0
var countdown_till_loss:int = 30 
var countdown_till_upgrade:int = 10 # 1 minutes
static var score_timer:float = 0.

static var end_game_messge: String = "You didn't stay within the power limit. "
var game_paused: bool = false:

	get:
		return game_paused
	set(value): 
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)
		
		
func _unhandled_input(event:InputEvent) -> void:
	# close program on esc button
	if event.is_action_pressed("ui_cancel"):
		if $pauseMenu.can_pause:
			game_paused = !game_paused
	
	if event is InputEventMouseButton and not event.is_pressed() and not game_paused and neutron_on_click:		
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var new_neutron:Node = neutron_scene.instantiate()
				new_neutron.initialize($Camera2D.get_global_mouse_position()) 
				add_child(new_neutron) 


# load map on ready
func _ready() -> void:
	# Load the scene
	var scene:Resource = load(self.map_to_load)
	
	# Instantiate the scene and Add the instance to the current scene
	map_loaded = scene.instantiate()
	add_child(map_loaded)
	$Control/Control/MarginContainer/VBoxContainer/Tree.set_vals()
	# tween in map 
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($Camera2D, "offset:y", 0, 0.8)
	$SceneFader.fade_out()	

	
	# set timers and settings
	$loss_timer.wait_time = countdown_till_loss
	$upgrade_timer.wait_time = countdown_till_upgrade
	_on_check_box_enrich_toggled(true)
	_on_check_box_spontain_neutron_emis_toggled(true)

	
	if game_mode_enabled:
		get_node("GameScore").show()
	else:
		get_node("GameScore").hide()
	


func _process(_delta: float) -> void:
	game_logic(_delta)
	update_hud()

func game_logic(dt:float) -> void:
	
	# count neutrons this doesnt need to be every 1/60 sec
	neutron_counter = len(get_tree().get_nodes_in_group("neutrons"))
	if game_mode_enabled and neutron_counter > 1000:
		end_game_messge = "
		Reactor reactivity is over.
		\n 1000 It's too much until 
		\n the game is optimzied sorry!"
		lost()
	
	# check if game should start
	if game_mode_enabled and game_not_started:
		if neutron_counter >= goal - margin_error:
			game_mode_enabled = true
			game_not_started = false
			$upgrade_timer.start()
			
	# if game is running, add score
	if game_mode_enabled and !game_paused and !game_not_started:
		score_timer += dt
		
		# check if you are out of bounds, then start loose timer
		var out_of_bounds_neutrons: bool = neutron_counter < goal - margin_error or neutron_counter > goal + margin_error
		if out_of_bounds_neutrons and $loss_timer.is_stopped():
			$loss_timer.start()
			globals.play(preload("res://assets/sounds/error.wav"))
		# stop loose timer if you recovered neutrons activity
		if !$loss_timer.is_stopped() and !out_of_bounds_neutrons:
				$loss_timer.stop()
				
func update_hud() -> void:
	'''
	This function updates the game HUD / visuals. Such as erichiment percent, the goal and so on.
	'''
	# TODO move this into the own script
	if Engine.get_physics_frames() % 15 == 1:

		# update game counter (score and such)
		if game_mode_enabled and $GameScore/GameScore.is_visible_in_tree():
			$GameScore.update_hud(
				self.score_timer,
				self.countdown_till_upgrade,
				self.countdown_till_loss,
				$upgrade_timer.time_left,
				$loss_timer.time_left,
			)
			
		# update neutron bar
		if $State/State.is_visible_in_tree():
			$State/State.set_current_value(neutron_counter)
		

		# Update enrich percent shower 
		if $Control/Control.is_visible_in_tree():
			var percent: float =  (float(Atom.enriched_present)/float(Atom.enriched_present + Atom.unenriched_present)) * 100
			$Control/Control/MarginContainer/VBoxContainer/Layer1/Enrich_bar.value = percent
			$Control/Control/MarginContainer/VBoxContainer/Layer1/Enrich_bar/Label.text = "Enrichment: " + '%.1f' % percent + "%"
			
			$Control/Control/MarginContainer/VBoxContainer/Layer1/enable_ctrl_rods.button_pressed = ControlRod.enable_auomatic
			$Control/Control/MarginContainer/VBoxContainer/Layer2/CheckBox_enrich.text = "Auto enrich " + str((1 - Atom.enrich_percent) * 100) + "%"
			$Control/Control/MarginContainer/VBoxContainer/Layer2/CheckBox_spontain_neutron_emis.button_pressed = Atom.enable_sponteniues_neutrons
			
func _on_check_box_enrich_toggled(toggled_on: bool) -> void:
	'''
	Starts auomatic enrichment of atoms
	'''
	$Control/Control/MarginContainer/VBoxContainer/Layer2/CheckBox_enrich.button_pressed = toggled_on
	if toggled_on:
		$enrich_timer.wait_time = Atom.enrich_speed
		$enrich_timer.start()
		Atom.enrich_check()
	else:
		$enrich_timer.stop()
		
		
func _on_enrich_timer_timeout() -> void:
	if Atom.enable_enrich:
		Atom.enrich_check()


func _on_check_box_spontain_neutron_emis_toggled(toggled_on: bool) -> void:
	Atom.enable_sponteniues_neutrons = toggled_on
	$Control/Control/MarginContainer/VBoxContainer/Layer2/CheckBox_spontain_neutron_emis.button_pressed = toggled_on
	if toggled_on:
		var atoms: Array[Node] = get_tree().get_nodes_in_group("atoms")
		for atom in atoms:
			if not atom.is_enriched:
				atom.start_spont_neutron_emission()


func build_grid_and_center(
		x_grid:int,
		y_grid:int,
		add_atoms:bool=true,
		add_ctrl:bool=true,
		encriched:bool=false,
		keep_enrich_percent:bool=true,
		ctlrod_spacer:int = 3,
		add_moderator:bool = false,
		add_water:bool=false,
		ignore_build:bool=false,
		expander:bool=false, 
	) -> void:
	'''
	builds or add atoms and control rods to grid and camera will center it. 
	'''
	var x_range:Array = []
	var y_range:Array = []
	
	if not ignore_build:
		x_range = range(x_row_build, x_grid)
		y_range = range(y_row_build, y_grid)
		
		# hack to reuse function to expand reatpr 
		if expander:
			if x_range == []:
				x_range = range(0, x_grid)
			if y_range == []:
				y_range = range(0, y_grid)
				if x_range[0] % ctlrod_spacer == 0 and add_ctrl and expander:
					var new_controlRod:Node = controlRod_scene.instantiate()
					new_controlRod.initialize(Vector2(margin + margin*x_range[0] +0.5*margin, 0)) 
					add_child(new_controlRod)
				
				if x_range[0] % ctlrod_spacer == 2 and add_moderator and expander:
					var new_moderator:Node = moderator_scene.instantiate()
					new_moderator.initialize(Vector2(margin + margin*x_range[0] +0.5*margin, 0)) 
					add_child(new_moderator)
		# store what has been build:
		x_row_build = x_grid
		y_row_build = y_grid
	else:
		x_range = range(0, x_grid)
		y_range = range(0, y_grid)
		
	for x:int in x_range:
		for y:int in y_range:
			
			if add_atoms:
				var new_atom:Node = atom_scene.instantiate()
				new_atom.initialize(Vector2(margin + margin*x, margin + margin*y), encriched, keep_enrich_percent) 
				add_child(new_atom) 
				
			if add_water:
				var new_water:Node = water_scene.instantiate()
				new_water.initialize(Vector2(margin + margin*x, margin + margin*y)) 
				add_child(new_water) 
		
		if x % ctlrod_spacer == 0 and add_ctrl and not expander:
			var new_controlRod:Node = controlRod_scene.instantiate()
			new_controlRod.initialize(Vector2(margin + margin*x +0.5*margin, 0)) 
			add_child(new_controlRod)
			
		if x % ctlrod_spacer == 2 and add_moderator and not expander:
			var new_moderator:Node = moderator_scene.instantiate()
			new_moderator.initialize(Vector2(margin + margin*x +0.5*margin, 0)) 
			add_child(new_moderator)


	# tween camera to center newly build grids of atoms. Only x position at the moment
	center_cam_atoms()
	

func center_cam_atoms() -> void:
	var atoms: Array[Node] = get_tree().get_nodes_in_group("atoms")
	var atom_x_positons: Array = []
	for atom in atoms:
		atom_x_positons.append(atom.global_position[0])
	var center_x: float = (atom_x_positons.min() + atom_x_positons.max())/2
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($Camera2D, "position", Vector2(center_x -1920/2., 0), 1)
	
	# also update ctr rods 
	ControlRod.update_control_rods()
	Moderator.update_mods()	
	
func lost() -> void:
	''' 
	Pop up message, save score, exit game. "size/viewport_width"
	'''
	game_paused = true
	game_mode_enabled = false
	$pauseMenu.game_over_display(score_timer)


func _on_loss_timer_timeout() -> void:
	lost()

# dict of possbilites for upgrades:
# TODO import this from physics changer and append the game margin things now itøs duplciated
var upgrade_dict:Dictionary = {
	# "↑ Reactor Size": make_bigger_reactor,
	"↑ Delayed Neutrons": [
		faster_delaed_neutrons,
		"Increases the ammount of random neutrons releaed by waste material"
	],
	"↑ Speed Enrichment": [
		faster_uranium_enrichment,
		"Increases the speed of the Uranium235 enrichment"
	],
	"↓ Control Rods Speed ": [
		slower_moving_control_rods,
		"Decreases the speed of the control rods"
	],
	"↑ Activity Goal": [
		higher_neutron_goal,
		"Increases the reactivity goal of the reactor"
	],
	"↓ Activity Error Margin": [
		smaller_neutron_margin,
		"Decreases the error margin of the neutron activity goal"
	],
	"↑ Enrichment Percent": [
		higher_enrichment_percent,
		"Allows the reactor to be enriched to higher grade"
	],
	"↑ Enrichment Chance": [
		higher_enrichment_chance,
		"Increases the chance an atom will be enriched isntantly after fission"
	],
}

func _on_upgrade_timer_timeout() -> void:
	'''
	generates 3 random upgrades and calls the pop up to ask whcih one user want
	'''
	
	game_paused = true
	var keys:Array = upgrade_dict.keys()
	keys.shuffle()
	var random_keys:Array = keys.slice(0, 3) 
	$pauseMenu.upgrade_game_mode(random_keys, upgrade_dict)
	

func call_upgrade(key:String) -> void:
	'''
	thhis function is called from the pop up, it will call the function to activate the user choice
	'''
	upgrade_dict[key][0].call()
	var add_x:int = 0
	var add_y:int = 0
	if float(x_row_build) / (y_row_build) > 1.6: # add only either row or colm
		add_y += 1
	else:
		add_x += 1
	# messy code. if atom enable moderation then its a rbmk reator. This function should find another way of finding out
	if Atom.enable_moderation:
			build_grid_and_center(
				x_row_build + add_x,
				y_row_build + add_y,
				true,
				true,
				true,
				false,
				4,
				true,
				true,
				false,
				true
			)
	else:
		build_grid_and_center(
				x_row_build + add_x,
				y_row_build + add_y,
				true,
				true,
				true,
				false,
				3,
				false,
				false,
				false,
				true
			)

func make_bigger_reactor() -> void:
	'''
	expands the reactor size with one row or one coloumn and centers it
	'''
	
	if float(x_row_build) / (y_row_build) > 1.6: # add only either row or colm
		for x in range(0, x_row_build):
			var new_atom:Node = atom_scene.instantiate()
			new_atom.initialize(Vector2(margin + margin*x, margin + margin*y_row_build), true) 
			add_child(new_atom) 
		y_row_build += 1
	else:
		for y in range(0, y_row_build):
			var new_atom:Node = atom_scene.instantiate()
			new_atom.initialize(Vector2(margin + margin*x_row_build, margin + margin*y), true) 
			add_child(new_atom) 
			
		if x_row_build % 3 == 0:
			
			# get pos of ctrl rod
			var ctrl_rods: Array = get_tree().get_nodes_in_group("ctrl_rods")
			var ctrl_rods_pos_y_to_mirror: ControlRod =  ctrl_rods[int(not ControlRod.last_created_even)]

			var new_controlRod:Node = controlRod_scene.instantiate()
			new_controlRod.initialize(Vector2(margin + margin*x_row_build +0.5*margin, ctrl_rods_pos_y_to_mirror.global_position.y)) 
			add_child(new_controlRod)
		x_row_build += 1
	
	center_cam_atoms()

	
	

func higher_enrichment_percent() -> void:
	Atom.enrich_percent *= 0.75
	
func higher_enrichment_chance() -> void:
	Atom.instant_enrich_chance *= 1.3
	
func faster_delaed_neutrons() -> void: 
	Atom.spont_emis_time *= 0.75 
	if Atom.enable_sponteniues_neutrons:
		var atoms: Array[Node] = get_tree().get_nodes_in_group("atoms")
		for atom in atoms:
			if not atom.is_enriched:
				atom.start_spont_neutron_emission()

func slower_moving_control_rods() -> void:
	ControlRod.speed *= 0.75
	
func smaller_neutron_margin() -> void:
	self.margin_error -= 10
	
func faster_uranium_enrichment() -> void:
	Atom.enrich_speed *= 0.5
	$enrich_timer.wait_time = Atom.enrich_speed

	
func higher_neutron_goal() -> void:
	self.goal += 100


func _on_check_box_enrich_2_toggled(toggled_on: bool) -> void:
	ControlRod.enable_auomatic = toggled_on
