extends Node

class_name GameRunner

static var map_to_load: String = "res://scenes/maps/basic_reactor.tscn"
static var map_loaded:Node = null
static var neutron_on_click: bool = true

# get fission objects
var neutron_scene:PackedScene = load("res://scenes/fission_objects/neutron.tscn")

signal toggle_game_paused(is_paused: bool)

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
				new_neutron.initialize(event.position) 
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
	
	if $State/State.is_visible_in_tree():
		# hslider
		$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons.value = Neutron.neutrons_present
		$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/value.text = str(Neutron.neutrons_present)
		# range is 0 - 360
		var pix_value = lerp(0.0, 360.0, float(Neutron.neutrons_present)/1000)
		$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/value.position[0] = pix_value - 20
		var min_accept_number = 301
		var min_accept_value = lerp(0.0, 360.0, float(min_accept_number)/1000)
		var max_accept_number = 602
		var max_accept_value = lerp(0.0, 360.0, float(max_accept_number)/1000)
		$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/min_accept.text = str(min_accept_number)
		$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/min_accept.position[0] = float(min_accept_value) - 10
		$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/max_accept.text = str(max_accept_number)
		$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/max_accept.position[0] = float(max_accept_value) - 10
		$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/accepted_range.position[0] = float(min_accept_value)
		$State/State/MarginContainer/VBoxContainer2/HSlider_neutrons/accepted_range.size[0] = float(max_accept_value) - float(min_accept_value)
		
		# percent enrich shower
		var percent: float =  (float(Atom.enriched_present)/float(Atom.enriched_present + Atom.unenriched_present)) * 100
		$State/State/MarginContainer/VBoxContainer2/ProgressBar.value = percent
		$State/State/MarginContainer/VBoxContainer2/ProgressBar/Label.text = "Enrichment: " + str("%.1f" %percent) + "%"
	
func _on_check_box_enrich_toggled(toggled_on: bool) -> void:
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
