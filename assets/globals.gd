extends Node

var neutrol_collide_slot: int = 1
var atoms_collide_slot: int = 2
var controlRods_collide_slot: int = 3
var moderator_neutron_slot: int = 4

func reset_game_var() -> void:
	Atom.enriched_present = 0
	Atom.unenriched_present = 0
	Neutron.neutrons_present = 0

	DebugMenu.style = DebugMenu.Style.HIDDEN
