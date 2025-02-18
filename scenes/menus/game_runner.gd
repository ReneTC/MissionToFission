extends Node

class_name GameRunner

static var map_to_load: String = "res://scenes/maps/basic_reactor.tscn"
static var map_loaded:Node = null
static var neutron_on_click: bool = true
var goal:float = 400
var margin_error:float = 100
# get fission objects
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")
var atom_scene:PackedScene = load("res://scenes/fission_objects/atom.tscn")
var controlRod_scene:PackedScene = load("res://scenes/fission_objects/controlRod.tscn")

signal toggle_game_paused(is_paused: bool)

# keep track on what grid has been build
var x_row_build:int = 0 
var y_row_build:int = 0 
var margin: int = 60

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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_hud()
	
	
func update_hud() -> void:
	'''
	This function updates the game HUD. Such as erichiment percent, the goal and so on.
	'''
	if $State/State.is_visible_in_tree():
		# only calc every 30 frame
		if Engine.get_physics_frames() % 15 == 1:
			$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons.value = Neutron.neutrons_present
			$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/value.text = str(Neutron.neutrons_present)

			var get_min_size:float = 370.0
			var get_slide_max_value:float = $State/State/MarginContainer/VBoxContainer2/HSlider_neutrons.max_value
			var pix_value:float = lerp(0.0, get_min_size, float(Neutron.neutrons_present)/get_slide_max_value)
			$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/value.position[0] = pix_value - 20
			var min_accept_value:float = lerp(0.0, get_min_size, float(goal - margin_error)/get_slide_max_value)
			var max_accept_value:float = lerp(0.0, get_min_size, float(goal +  margin_error)/get_slide_max_value)
			$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/min_accept.text = str(goal - margin_error)
			$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/min_accept.position[0] = float(min_accept_value) - 10
			$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/max_accept.text = str(goal + margin_error)
			$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/max_accept.position[0] = float(max_accept_value) - 10
			$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/accepted_range.position[0] = float(min_accept_value)
			$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/accepted_range.size[0] = float(max_accept_value) - float(min_accept_value)
			# adjust size
			# var max_accept_number = 300 # test
	
			# percent enrich shower
			var percent: float =  (float(Atom.enriched_present)/float(Atom.enriched_present + Atom.unenriched_present)) * 100
			$State/State/MarginContainer/VBoxContainer2/ProgressBar.value = percent
			$State/State/MarginContainer/VBoxContainer2/ProgressBar/Label.text = "Enrichment: " + str("%.1f" %percent) + "%"
			
		
func _on_check_box_enrich_toggled(toggled_on: bool) -> void:
	'''
	Starts auomatic enrichment of atoms
	'''
	Atom.set_auto_enrich(toggled_on)
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
	# store 
	
	# add atoms 
	for x in range(0,x_grid):
		for y in range(0, y_grid): 
			var new_atom:Node = atom_scene.instantiate()
			new_atom.initialize(Vector2(margin + margin*x, margin + margin*y), true) 
			add_child(new_atom) 

		if x % 3 == 0:
			var new_controlRod:Node = controlRod_scene.instantiate()
			new_controlRod.initialize(Vector2(margin + margin*x +0.5*margin, 0)) 
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
	tween.tween_property($Camera2D, "position", Vector2(center_x, 0), 2)
