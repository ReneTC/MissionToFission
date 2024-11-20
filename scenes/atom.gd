extends Area2D
class_name Atom

@export var number_neutrons_emitted = 3
@export var radius = 20

@export var color_enriched = Color("2D8EFF")
@export var color_decayed = Color("DCEEFF")
@export var is_enriched = true

var life_time
var neutron_scene: PackedScene
var excited = true
@onready var parent = self.get_parent()

var geiger_sound = preload("res://assets/geig.mp3")

static var enriched_present = 0
static var unenriched_present = 0

func _ready() -> void:
	neutron_scene = load("res://scenes/neutron.tscn")
	self.connect("body_entered", on_body_entered)
	
	# set collsion size
	$CollisionShape2D.shape.radius = self.radius
	
	set_collision_mask_value(globals.neutrol_collide_slot, true)
	
	if self.excited:
		enriched_present += 1
	else:
		unenriched_present += 1
	
func initialize(pos_to_set, encriched):
	position = pos_to_set
	is_enriched = encriched


func _draw():
	var color_to_draw = null
	# draw status 
	if is_enriched: color_to_draw = color_enriched
	else: color_to_draw = color_decayed
	draw_circle(Vector2(0, 0), self.radius, color_to_draw)


func on_body_entered(body: Node):
	if excited == true and body is Neutron:
		decay()
		emit_neutrons(self.number_neutrons_emitted)
		

		body.queue_free()
		
		
func decay():
	excited = false
	self.is_enriched = false
	
	unenriched_present += 1
	enriched_present -= 1
	# disable collison check w neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, false)
	
	queue_redraw()
	
	
func enrich():
	self.is_enriched = true
	unenriched_present -= 1
	enriched_present += 1
	# enable collsion check w neutrons again
	set_collision_mask_value(globals.neutrol_collide_slot, true)
	queue_redraw()

	
func emit_neutrons(neutrons_to_emit):
	for i in range(neutrons_to_emit):
		var new_neutron = neutron_scene.instantiate()
		new_neutron.initialize(position) 
		parent.call_deferred("add_child", new_neutron)
