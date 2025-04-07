extends Node

var neutrol_collide_slot: int = 1
var atoms_collide_slot: int = 2
var controlRods_collide_slot: int = 3
var moderator_neutron_slot: int = 4

# reset keep and keep check of default settings
func reset_game_var() -> void:
	Atom.enriched_present = 0
	Atom.unenriched_present = 0
	Atom.enable_moderation = false
	Atom.enable_xenon = false
	Atom.enable_sponteniues_neutrons = false
	
	Neutron.enable_moderation = false
	Water.water_absorb_chance = 0.00

	DebugMenu.style = DebugMenu.Style.HIDDEN


func get_random_uninrched_atom() -> Node:
	var atoms: Array = get_tree().get_nodes_in_group("atoms")
	var filtered: Array = atoms.filter(func(x): return not x.is_enriched and not x.is_xenon)
	return filtered.pick_random() if filtered.size() > 0 else null
