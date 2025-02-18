extends Node2D

var x_grid_range: int = 15
var y_grid_range: int = 10
var margin: int = 60
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_node("Control").show()
	get_parent().get_node("State").show()
	# set enrichment atom settings 
	Atom.keep_enriched = false
	# Atom.enable_sponteniues_neutrons = false
	# Atom.enrich_percent = 0.95
	
	# set atoms and controlRods
 
	# tween in center caamera
	
	get_parent().build_grid_and_center(x_grid_range, y_grid_range)
