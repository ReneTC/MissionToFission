extends Area2D
class_name Atom

@export var number_neutrons_emitted: int = 3
@export var radius: float = 20

@export var color_enriched:Color = Color("2D8EFF")
@export var color_decayed:Color = Color("BBBBBB")
@export var is_enriched: bool = true

# timer to not allow enrichment right away after fission
var enirch_timer:bool = true

var neutron_scene: PackedScene

@onready var parent:Node = self.get_parent()


# enrich static settings
static var enriched_present: int = 0
static var unenriched_present: int = 0
static var keep_enriched: bool = false
static var enrich_percent: float = 0.80

static var enable_moderation:bool = false
func _ready() -> void:
	neutron_scene = load("res://scenes/fission_objects/neutron.tscn")
	self.connect("body_entered", on_body_entered)
	
	# set collsion size
	$CollisionShape2D.shape.radius = self.radius
	
	set_collision_mask_value(globals.neutrol_collide_slot, true)
	
	if self.is_enriched:
		enriched_present += 1
	else:
		unenriched_present += 1
		
	add_to_group("atoms")
	
	
func initialize(pos_to_set:Vector2, encriched:bool) -> void:
	position = pos_to_set
	is_enriched = encriched


func _draw() -> void:
	var color_to_draw:Color = color_decayed
	if is_enriched: color_to_draw = color_enriched
	draw_circle(Vector2(0, 0), self.radius, color_to_draw)


func on_body_entered(body: Node) -> void:
	if is_enriched == true and body is Neutron:
		decay()
		emit_neutrons(self.number_neutrons_emitted)
		
		# delete neutron
		Neutron.neutrons_present -= 1
		body.queue_free()
		
		
func decay() -> void:
	# check if random atom should enrich 
	if keep_enriched:
		enrich_check()
	
	self.enirch_timer = false
	self.is_enriched = false
	
	unenriched_present += 1
	enriched_present -= 1
	# disable collison check for decayed atom with neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, false)
	queue_redraw()
	
	# start timer to not allow enrichjment right away
	$Timer.start()



func enrich_check() -> void:
	if float(unenriched_present)/float(unenriched_present+enriched_present) > enrich_percent:
		# keep looping until unenriched atom is enriched 
			var random_atom:Node = get_tree().get_nodes_in_group("atoms").pick_random() 
			if not random_atom.is_enriched and random_atom.enirch_timer:
				random_atom.enrich()
				
			
	
func enrich() -> void:
	self.is_enriched = true
	unenriched_present -= 1
	enriched_present += 1
	# enable collsion check w neutrons again
	set_collision_mask_value(globals.neutrol_collide_slot, true)
	queue_redraw()

	
func emit_neutrons(neutrons_to_emit:int) -> void:
	for i in range(neutrons_to_emit):
		var new_neutron:Node = neutron_scene.instantiate()
		new_neutron.initialize(position) 
		parent.call_deferred("add_child", new_neutron)


func _on_timer_timeout() -> void:
	enirch_timer = true
	enrich_check()
