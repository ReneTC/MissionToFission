extends Area2D
class_name ControlRod

@export var height = 400
@export var width = 10
@export var color = Color("1A1A1A")
@export var speed = 10


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
	
# delete neutron on enter
func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
	Neutron.neutrons_present -= 1



func get_input():
	if Input.is_action_pressed("q"):
		position.y += speed
	if Input.is_action_pressed("e"):
		position.y -= speed

func _physics_process(_delta):
	get_input()
