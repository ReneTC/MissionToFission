extends Node2D

func _ready() -> void:
	# disable spawn click with mouse
	GameRunner.neutron_on_click = false
	
	# disable neutron counter 
	get_parent().get_node("MarginContainer").hide()
	Dialogic.start("tutorial")
