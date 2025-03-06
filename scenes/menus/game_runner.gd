extends Node

class_name GameRunner

static var map_to_load: String = "res://scenes/maps/basic_reactor.tscn"
static var map_loaded:Node = null
static var neutron_on_click: bool = true

# get fission objects
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")

signal toggle_game_paused(is_paused: bool)

# keep track on what grid has been build
var x_row_build:int = 0 
var y_row_build:int = 0 
var margin: int = 60

# game settings
var game_mode_enabled: bool = false
var goal:float = 400
var margin_error:float = 100
var countdown_till_loss:int = 30 
var countdown_till_upgrade:int = 10 # 1 minutes
var score_timer:float = 0.
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
	
	# Instantiate the scene
	map_loaded = scene.instantiate()
	# Add the instance to the current scene
	add_child(map_loaded)
	
	# tween in map 
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($Camera2D, "offset:y", 0, 0.8)
	$SceneFader.fade_out()	
	
	# get input of bottoms 
	$Control/Control/MarginContainer/VBoxContainer/CheckBox_enrich.button_pressed = Atom.keep_enriched
	
	# set timers 
	$loss_timer.wait_time = countdown_till_loss
	$upgrade_timer.wait_time = countdown_till_upgrade

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	game_logic(_delta)
	update_hud()
	


func game_logic(dt:float) -> void:
	# check if game should start
	if !game_mode_enabled:
		if Neutron.neutrons_present >= goal - margin_error:
			game_mode_enabled = true
			$upgrade_timer.start()
			
	# if game is running, add score
	if game_mode_enabled and !game_paused:
		score_timer += dt
		
		# check if you are out of bounds, then start loose timer
		var out_of_bounds_neutrons: bool = Neutron.neutrons_present <= goal - margin_error or Neutron.neutrons_present >= goal + margin_error
		if out_of_bounds_neutrons and $loss_timer.is_stopped():
			$loss_timer.start()
		# stop loose timer if you recovered neutrons activity
		if !$loss_timer.is_stopped() and !out_of_bounds_neutrons:
				$loss_timer.stop()
				
func update_hud() -> void:
	'''
	This function updates the game HUD / visuals. Such as erichiment percent, the goal and so on.
	'''
	if Engine.get_physics_frames() % 15 == 1:
		
		# update game counter (score and such)
		if game_mode_enabled and $GameScore/GameScore.is_visible_in_tree():
			$GameScore/GameScore/MarginContainer/VBoxContainer2/Button.text = "Survive: %.1f" % score_timer
			$GameScore/GameScore/MarginContainer/VBoxContainer2/Button2.text = "Upgrade: %d" % $upgrade_timer.time_left
			$GameScore/GameScore/MarginContainer/VBoxContainer2/Button3.text = "Loose: %d" % $loss_timer.time_left

			$"GameScore/GameScore/MarginContainer/VBoxContainer2/upgrade-bar".max_value = countdown_till_upgrade
			$"GameScore/GameScore/MarginContainer/VBoxContainer2/upgrade-bar".value = $upgrade_timer.time_left
			$"GameScore/GameScore/MarginContainer/VBoxContainer2/loose-bar".max_value = countdown_till_loss
			$"GameScore/GameScore/MarginContainer/VBoxContainer2/loose-bar".value = $loss_timer.time_left
	
		# update neutron bar
		if $State/State.is_visible_in_tree():
			$State/State/Label.text =  str(Neutron.neutrons_present)
			$State/State/HSlider_neutrons.accepted_range = Vector2(goal - margin_error, goal + margin_error)
			$State/State/HSlider_neutrons.set_current_value(Neutron.neutrons_present)
		

		# Update enrich percent shower 
		if $Control/Control.is_visible_in_tree():
			var percent: float =  (float(Atom.enriched_present)/float(Atom.enriched_present + Atom.unenriched_present)) * 100
			$Control/Control/MarginContainer/VBoxContainer/ProgressBar.value = percent
			$Control/Control/MarginContainer/VBoxContainer/ProgressBar/Label.text = "Enrichment: " + str("%.1f" %percent) + "%"
			
		
func _on_check_box_enrich_toggled(toggled_on: bool) -> void:
	'''
	Starts auomatic enrichment of atoms
	'''
	Atom.set_auto_enrich(toggled_on)
	# Update text
	$Control/Control/MarginContainer/VBoxContainer/CheckBox_enrich.text = "Auto enrich " + str((1 - Atom.enrich_percent) * 100) + "%"
	
	if toggled_on:
		$enrich_timer.start()
		Atom.enrich_check()
	else:
		$enrich_timer.stop()
		
		
func _on_enrich_timer_timeout() -> void:
	Atom.enrich_check()


func _on_check_box_spontain_neutron_emis_toggled(toggled_on: bool) -> void:
	Atom.enable_sponteniues_neutrons = toggled_on
	if toggled_on:
		var atoms: Array = get_tree().get_nodes_in_group("atoms")
		for atom in atoms:
			if not atom.is_enriched:
				atom.start_spont_neutron_emission()


func build_grid_and_center(x_grid, y_grid) -> void:
	'''
	builds or add atoms and control rods to grid and camera will center it. 
	'''
	# add atoms 
	for x in range(0,x_grid):
		for y in range(0, y_grid): 
			var new_atom:Node = atom_scene.instantiate()
			new_atom.initialize(Vector2(margin + margin*x, margin + margin*y), true) 
			add_child(new_atom) 

		if x % 3 == 0:
			var new_controlRod:Node = controlRod_scene.instantiate()
			new_controlRod.initialize(Vector2(margin + margin*x +0.5*margin, -300)) 
			add_child(new_controlRod)
			
	# tween camera to center newly build grids of atoms. Only x position at the moment
	var atoms: Array = get_tree().get_nodes_in_group("atoms")
	var atom_x_positons = []
	for atom in atoms:
		atom_x_positons.append(atom.global_position[0])
	var center_x = (atom_x_positons.min() + atom_x_positons.max())/2 - $Camera2D.get_screen_center_position()[0]
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($Camera2D, "position", Vector2(center_x, 0), 1)
