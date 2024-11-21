extends RigidBody2D
class_name Neutron

@export var radius = 5
@export var color = Color("1A1A1A")

static var neutrons_present = 0

func _ready() -> void:
	# set collsion size
	$CollisionShape2D.shape.radius = self.radius
	
	# sound effect geiger
	$AudioStreamPlayer2D.stream = preload("res://assets/geig.mp3")
	$AudioStreamPlayer2D.play()
	
	# set collide settings 
	set_collision_layer_value(globals.neutrol_collide_slot, true)
	
	neutrons_present += 1
	

func _draw():
	draw_circle(Vector2(0, 0), self.radius, self.color)
	
func initialize(pos_to_set):
	position = pos_to_set

	var movement_direction = Vector2(randf() - 0.5, randf() - 0.5)
	movement_direction /= movement_direction.length()
	linear_velocity = 100 * movement_direction



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	neutrons_present -= 1
