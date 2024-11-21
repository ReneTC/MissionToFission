extends Node

var neutrol_collide_slot = 1
var atoms_collide_slot = 2
var controlRods_collide_slot = 3

func _input(_event) -> void:
	# close program on esc button
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
			
