extends Node2D

var x_grid_range: int = 10
var y_grid_range: int = 5
var margin: int = 60
var game_runner_instant = null
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	# send game settings 
	var game_runner_instant = get_parent()
	game_runner_instant.goal = 500
	game_runner_instant.margin_error = 400
	
	get_parent().get_node("Control").show()
	get_parent().get_node("State").show()
	get_parent().get_node("GameScore").show()


	Atom.keep_enriched = false
 
	# tween in center caamera
	game_runner_instant.build_grid_and_center(x_grid_range, y_grid_range)
