extends Tree
@onready var tree: Node = $"."

var upgrade_dict:Dictionary = {
	# key: [func, tooltip, currentval, min, max, step]
	"TIme until Delayed Neutron": [
		"func_faster_delaed_neutrons",
		"Ammount of random neutrons releaed by waste material",
		Atom.spont_emis_time,
		0.01, 
		10,
		0.1,
	],
	"Time Until Enrichment": [
		"func_faster_uranium_enrichment",
		"The Speed of the Uranium235 enrichment",
		Atom.enrich_speed,
		0.01, 
		10,
		0.1
	],
	
	"Control Rods Speed ": [
		"func_slower_moving_control_rods",
		"The speed of the control rods",
		ControlRod.speed,
		10,
		100,
		5
		
	],
	"Enrichment Percent": [
		"func_higher_enrichment_percent",
		"Allows the reactor to be enriched to higher grade",
		int(roundf((1-Atom.enrich_percent)*100)),
		0,
		100,
		1
	],
	"Instant Enrichment Chance": [
		"func_higher_enrichment_chance",
		"Increases the chance a random atom will be enriched isntantly after fission",
		int(roundf((Atom.instant_enrich_chance)*100)),
		0,
		100,
		5
	],
}

	
func _ready() -> void:
	
	# create root and rename it
	var root: TreeItem = tree.create_item()
	root.set_text(0, "Settings")
	for key:String in upgrade_dict:
		var section: TreeItem = tree.create_item(root)
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
	tree.set_custom_minimum_size(Vector2(500, 30))

func set_vals() -> void:
	'''
	Update the ui values 
	'''
	var sections: Array = tree.get_root().get_children()
	# just manual set them now
	sections[0].set_range(0, Atom.spont_emis_time)
	sections[1].set_range(0, Atom.enrich_speed)
	sections[2].set_range(0, ControlRod.speed)
	sections[3].set_range(0, int(roundf((1-Atom.enrich_percent)*100)))
	sections[4].set_range(0, int(roundf((1-Atom.instant_enrich_chance)*100)))
	
	
func _on_item_edited() -> void:
	# TODO make this uatomatic and make all val percentages isntead of decimals
	# update all valls here
	var sections: Array = tree.get_root().get_children()
	# just manual set them now
	Atom.spont_emis_time = sections[0].get_range(0)
	
	Atom.enrich_speed = sections[1].get_range(0)
	
	ControlRod.speed = sections[2].get_range(0)
	
	Atom.enrich_percent = 1 - (float(sections[3].get_range(0))/100)
	
	Atom.instant_enrich_chance = float(sections[4].get_range(0))/100
	

	# update all values  for spont time
	var atoms: Array[Node] = get_tree().get_nodes_in_group("atoms")
	for atom in atoms:
		if not atom.is_enriched:
			atom.start_spont_neutron_emission()

	# update enrich clock 
	$"../../../../../enrich_timer".wait_time = Atom.enrich_speed 
	

func reset_vals() -> void:
	globals.reset_game_var()
	self.set_vals()
	
