extends Node2D

var x_grid_range: int = 10
var y_grid_range: int = 5
var margin: int = 60
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	# send game settings 
	
	GameRunner.game_mode_enabled = true
	GameRunner.goal = 150
	GameRunner.margin_error = 140
	
	get_parent().get_node("Control").show()
	get_parent().get_node("State").show()
	get_parent().get_node("GameScore").show()

 
	# tween in center caamera
	var game_runner_instant: Node = get_parent()
	game_runner_instant.build_grid_and_center(x_grid_range, y_grid_range)
