extends Tree
@onready var tree = $"."

var upgrade_dict:Dictionary = {
	# key: [func, tooltip, currentval, min, max, step]
	"Delayed Neutrons": [
		"func_faster_delaed_neutrons",
		"Increases the speed of random neutrons releaed by waste material",
		Atom.spont_emis_time,
		0.01, 
		10,
		0.1,
	],
	"Speed Enrichment": [
		"func_faster_uranium_enrichment",
		"Increases the speed of the Uranium235 enrichment",
		Atom.enrich_speed,
		0.01, 
		10,
		0.1
	],
	"Control Rods Speed ": [
		"func_slower_moving_control_rods",
		"Decreases the speed of the control rods",
		ControlRod.speed,
		10,
		100,
		5
		
	],
	"Enrichment Percent": [
		"func_higher_enrichment_percent",
		"Allows the reactor to be enriched to higher grade",
		Atom.enrich_percent,
		100,
		0,
		5
	],
	"Enrichment Chance": [
		"func_higher_enrichment_chance",
		"Increases the chance an atom will be enriched isntantly after fission",
		Atom.instant_enrich_chance,
		100,
		0,
		5
	],
}

	
func _ready() -> void:
	# create root and rename it
	var root = tree.create_item()
	root.set_text(0, "Settings")
	
	var game_runner_instant: Node = get_parent()
	for key in upgrade_dict:
		var section = tree.create_item(root)
		section.set_range(0, 2)
		section.set_cell_mode(0, TreeItem.CELL_MODE_RANGE)
		section.set_editable(0, true)
		section.set_selectable(0, false)
		section.set_range(0, upgrade_dict[key][2])
		section.set_range_config(0, upgrade_dict[key][3], upgrade_dict[key][4], upgrade_dict[key][5])
		section.set_suffix(0, key)
		section.set_tooltip_text(0, upgrade_dict[key][1])

func _on_mouse_entered() -> void:
	tree.set_custom_minimum_size(Vector2(500, 220))

func _on_mouse_exited() -> void:
	tree.set_custom_minimum_size(Vector2(500, 40))
	
	


func _on_item_edited() -> void:
	# update all valls here
	# change all values to use percent not decimals
	var sections = tree.get_root().get_children()
	
	print(sections.get_range(0))
	# just manual set them now
	#Atom.spont_emis_time = sections.get_range(0)
	#Atom.enrich_speed = sections.get_range(1)
	#ControlRod.speed = sections.get_range(2)
	#Atom.enrich_percent = sections.get_range(3)
	#Atom.instant_enrich_chance = sections.get_range(4)
