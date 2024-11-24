extends Node

var neutrol_collide_slot: int = 1
var atoms_collide_slot: int = 2
var controlRods_collide_slot: int = 3
var moderator_neutron_slot: int = 4

func _input(_event:InputEvent) -> void:
	# close program on esc button
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
			
