extends rbmk_reactor

func _ready() -> void:
	# set map settings 
	# Atom.enrich_percent = 0.5
	Atom.enable_moderation = true
	Atom.enable_xenon = true
	Neutron.enable_moderation = true


	# set game settings 
	GameRunner.game_mode_enabled = true
	GameRunner.goal = 100
	GameRunner.margin_error = 100
	get_parent().get_node("Control").show()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Layer2").hide()
	get_parent().get_node("Control/Control/MarginContainer/VBoxContainer/Tree").hide()
	get_parent().get_node("State").show()
	get_parent().get_node("GameScore").show()
 
	# tween in center caamera
	x_grid_range = 10
	y_grid_range = 5

	get_parent().build_grid_and_center(x_grid_range, y_grid_range, true, true, false, true, 4, true, true)
