extends Area2D
class_name Atom

@export var number_neutrons_emitted: int = 3
@export var radius: float = 20

var color_enriched:Color = Color("2D8EFF")
var color_decayed:Color = Color("BBBBBB")
var color_xenon:Color = Color("444444")
@export var is_enriched: bool = true
@export var is_xenon: bool = false
var become_xenon_later_chance: float = 0.5 
var xenon_time_rand_multiplier:float = 10
# timer to not allow enrichment right away after fission

var enirch_timer:bool = true

var neutron_scene: PackedScene

@onready var parent:Node = self.get_parent()


# enrich static settings
static var enriched_present: int = 0
static var unenriched_present: int = 0
static var enrich_percent: float = 0.80

static var keep_enriched: bool = false
static var enable_moderation:bool = false
static var enable_xenon:bool = false
static var enable_sponteniues_neutrons:bool = false

func get_random_decay_time() -> float:
	return 50. * randf() + 2.

func _ready() -> void:
	neutron_scene = load("res://scenes/fission_objects/neutron.tscn")
	self.connect("body_entered", on_body_entered)
	
	# set collsion size
	$CollisionShape2D.shape.radius = self.radius
	
	if self.is_enriched:
		set_collision_mask_value(globals.neutrol_collide_slot, true)
	else:
		if self.enable_sponteniues_neutrons:
			$Timer_spontenius_neutron_emission.start(get_random_decay_time())
			$Timer_spontenius_neutron_emission.paused = false
	# look for fast nuetrons 
	if self.enable_moderation and self.is_enriched:
		set_collision_mask_value(globals.moderator_neutron_slot, true)
	
	if self.is_enriched:
		enriched_present += 1
	else:
		unenriched_present += 1
		
	add_to_group("atoms")
	
	
func initialize(pos_to_set:Vector2, encriched:bool = true) -> void:
	position = pos_to_set
	is_enriched = encriched


func _draw() -> void:
	var color_to_draw:Color = color_decayed
	if is_enriched: color_to_draw = color_enriched
	elif is_xenon: color_to_draw = color_xenon
	draw_circle(Vector2(0, 0), self.radius, color_to_draw)


func on_body_entered(body: Node) -> void:
	if body is Neutron:
		if self.is_xenon and Atom.enable_xenon:	
			self.is_xenon = false 
			queue_redraw()
			
			# delete neutron
			Neutron.neutrons_present -= 1
			body.queue_free()

		if is_enriched == true and not body.is_fast:
			decay()
			emit_neutrons(self.number_neutrons_emitted)
		
			# delete neutron
			Neutron.neutrons_present -= 1
			body.queue_free()
		
		
func decay() -> void:
	# check if random atom should enrich
	
	if keep_enriched:
		enrich_check()
		
	if not self.is_xenon and Atom.enable_xenon:
		# not all should become xenon
		if randf() < self.become_xenon_later_chance:
			$Timer_Xenon.start(randf() * self.xenon_time_rand_multiplier)
	
	self.enirch_timer = false
	
	$Timer_enrich_wait.start()
	
	self.is_enriched = false

	if enable_sponteniues_neutrons:
		$Timer_spontenius_neutron_emission.start(get_random_decay_time())


	unenriched_present += 1
	enriched_present -= 1

	# disable collison check for decayed atom with neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, false)
	if enable_moderation:
		set_collision_mask_value(globals.moderator_neutron_slot, false)
	queue_redraw()
	

func enrich_check() -> void:
	if float(unenriched_present)/float(unenriched_present+enriched_present) > enrich_percent:
		# keep looping until unenriched atom is enriched 
			var random_atom:Node = get_tree().get_nodes_in_group("atoms").pick_random() 
			if not random_atom.is_enriched and random_atom.enirch_timer:
				random_atom.enrich()


func enrich() -> void:
	self.is_enriched = true
	if self.enable_sponteniues_neutrons:
		$Timer_spontenius_neutron_emission.paused = true
	unenriched_present -= 1
	enriched_present += 1
	# enable collsion check w neutrons again
	set_collision_mask_value(globals.neutrol_collide_slot, true)

	# also fast neutrons 
	if enable_moderation:
		set_collision_mask_value(globals.moderator_neutron_slot, true)

	queue_redraw()

	
func emit_neutrons(neutrons_to_emit:int) -> void:
	for i in range(neutrons_to_emit):
		var new_neutron:Node = neutron_scene.instantiate()
		new_neutron.initialize(position) 
		parent.call_deferred("add_child", new_neutron)

# on timout, atoms will be able to be selected for enrichement at random
func _on_timer_enrich_wait_timeout() -> void:
	enirch_timer = true
	enrich_check()


# becomes xenon
func _on_timer_xenon_timeout() -> void:
	self.is_xenon = true
	set_collision_mask_value(globals.neutrol_collide_slot, true)

	if enable_moderation:
		set_collision_mask_value(globals.moderator_neutron_slot, true)
	queue_redraw()


func _on_timer_spontenius_neutron_emission_timeout() -> void:
	$Timer_spontenius_neutron_emission.wait_time = get_random_decay_time()
	var new_neutron:Node = neutron_scene.instantiate()
	new_neutron.initialize(position) 
	parent.call_deferred("add_child", new_neutron)
