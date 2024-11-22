extends Area2D
class_name Moderator

@export var height: float = 800
@export var width: float = 10
@export var color = Color("00ff00")
@export var speed: float = 10


func _ready() -> void:
	# set collisohape to set varables
	var rectangle_shape =  $CollisionShape2D.shape as RectangleShape2D
	rectangle_shape.extents = Vector2(self.width/2., self.height/2.) 
	
	# enable collison check w neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, true)


func _draw():
	draw_rect(Rect2(-self.width/2., -self.height/2., self.width, self.height), self.color)


func initialize(pos_to_set):
	position = Vector2(pos_to_set[0], pos_to_set[1])
	
	




func _on_body_entered(body: Node2D) -> void:
	body.linear_velocity[0] = -body.linear_velocity[0]
