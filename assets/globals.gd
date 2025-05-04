extends Node

var neutrol_collide_slot: int = 1
var atoms_collide_slot: int = 2
var controlRods_collide_slot: int = 3
var moderator_neutron_slot: int = 4

# reset keep and keep check of default settings
func reset_game_var() -> void:
	
	Atom.enriched_present = 0
	Atom.unenriched_present = 0
	Atom.enrich_percent = 0.80
	Atom.enable_instant_enrich = true
	Atom.instant_enrich_chance = 0.25
	Atom.enable_sponteniues_neutrons = true
	Atom.spont_emis_time = 1.0 
	Atom.enrich_speed = 1.0
	Atom.enable_enrich = true
	Atom.become_xenon_later_chance = 0.25 
	Atom.enable_moderation = false
	Atom.enable_xenon = false

	GameRunner.x_row_build = 0 
	GameRunner.y_row_build = 0 
	GameRunner.margin = 60
	GameRunner.game_mode_enabled = false
	GameRunner.game_not_started = true
	GameRunner.goal = 400
	GameRunner.score_timer = 0
	GameRunner.margin_error = 100
	GameRunner.neutron_counter = 0
	GameRunner.end_game_messge = "You didn't stay within the power limit. "

	ControlRod.speed = 65
	ControlRod.enable_auomatic  = true
	ControlRod.move_even = true
	ControlRod.last_created_even = true
	ControlRod._registered_nodes = []
	
	Moderator._registered_nodes = []

	Water.water_absorb_chance = 0.05
	Water.cool_of_speed = 10	
	
	DebugMenu.style = DebugMenu.Style.HIDDEN


func get_random_uninrched_atom() -> Node:
	var atoms: Array = get_tree().get_nodes_in_group("atoms")
	var filtered: Array = atoms.filter(func(x: Atom) -> bool: return not x.is_enriched and not x.is_xenon)
	return filtered.pick_random() if filtered.size() > 0 else null

func play(audio: AudioStream) -> void:
	var audio_player := AudioStreamPlayer2D.new()
	audio_player.stream = audio
	Engine.get_main_loop().root.add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
