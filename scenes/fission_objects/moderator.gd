extends Area2D
class_name Moderator

@export var height: float = 800
@export var width: float = 10
@export var color:Color = Color("1A1A1A")
@export var speed: float = 10


func _ready() -> void:
	# set collisohape to set varables
	var rectangle_shape:RectangleShape2D =  $CollisionShape2D.shape as RectangleShape2D
	rectangle_shape.extents = Vector2(self.width/2., self.height/2.) 
	
	# enable collison check w neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, true)


func _draw() -> void:
	draw_rect(Rect2(-self.width/2., -self.height/2., self.width, self.height), Color("ffffff"))
	draw_rect(Rect2(-self.width/2.+1, -self.height/2.+1, self.width+1, self.height+1), self.color, false)


func initialize(pos_to_set:Vector2) -> void:
	position = Vector2(pos_to_set[0], pos_to_set[1])
	
func _on_body_entered(body: Node2D) -> void:
	body.linear_velocity[0] = -body.linear_velocity[0]
