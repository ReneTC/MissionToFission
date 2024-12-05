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
		
		
func _input(event:InputEvent) -> void:
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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$MarginContainer/VBoxContainer/MarginContainer/ButtonsVBox/Button.text = "Neutrons: " + str(Neutron.neutrons_present)
	$MarginContainer/VBoxContainer/MarginContainer/ButtonsVBox/Button2.text = "Uranium235: " + str(Atom.enriched_present)


func _on_check_box_enrich_toggled(toggled_on: bool) -> void:
	Atom.keep_enriched = toggled_on

func _on_check_box_sne_toggled(toggled_on: bool) -> void:
	Atom.enable_sponteniues_neutrons = toggled_on
