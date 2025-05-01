extends RigidBody2D
class_name Neutron

@export var radius: float = 5.
@export var color:Color = Color("444444")
var thermal_speed:float = 100
var current_speed:float = thermal_speed
var fast_speed:float = 200
var is_fast:bool = false



static var enable_moderation:bool = false

func _ready() -> void:
	# set collsion size
	$CollisionShape2D.shape.radius = self.radius

	# sound effect geiger
	$AudioStreamPlayer2D.play()
	
	# set collide settings 
	set_collision_layer_value(globals.neutrol_collide_slot, true)
	

	
	add_to_group("neutrons")
	
	if enable_moderation:
		set_collision_layer_value(globals.moderator_neutron_slot, true)
		set_collision_layer_value(globals.neutrol_collide_slot, false)
		is_fast = true 
	

func _draw() -> void:
	draw_circle(Vector2(0, 0), self.radius, self.color)
	
	# draw inner white circle as dot to indicate fast neutron
	if is_fast:
		var radi:float =  lerp(0., 0.5, (current_speed-100.)/100.)
		draw_circle(Vector2(0, 0), self.radius*radi, Color("FFFFFF"))


func get_random_direction() -> Vector2:
	var movement_direction:Vector2 = Vector2(randf() - 0.5, randf() - 0.5).normalized()
	return movement_direction
	

func initialize(pos_to_set:Vector2, movement_direction:Vector2 = get_random_direction()) -> void:
	position = pos_to_set

	if enable_moderation:
		self.current_speed = self.fast_speed
	linear_velocity = self.current_speed * movement_direction


func kill_self() -> void:
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	kill_self()
