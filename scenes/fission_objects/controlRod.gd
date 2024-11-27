extends Area2D
class_name ControlRod

@export var height: float = 900
@export var width: float = 10
@export var color:Color = Color("444444")
@export var speed: float = 1


func _ready() -> void:
	# set collisohape to set varables
	var rectangle_shape:Shape2D =  $CollisionShape2D.shape as RectangleShape2D
	rectangle_shape.extents = Vector2(self.width/2., self.height/2.) 
	
	# enable collison check w neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, true)

	# also fast neutrons
	set_collision_mask_value(globals.moderator_neutron_slot, true)


func _draw() -> void:
	draw_rect(Rect2(-self.width/2., -self.height/2., self.width, self.height), self.color)


func initialize(pos_to_set:Vector2) -> void:
	position = Vector2(pos_to_set[0], pos_to_set[1])
	
# delete neutron on enter
func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
	Neutron.neutrons_present -= 1



func get_input() -> void:
	var direction:float = 0
	if Input.is_action_pressed("q"):
		direction = speed
	if Input.is_action_pressed("e"):
		direction = -speed

	position.y = clamp(position.y+direction*speed, -420, 480)

func _physics_process(_delta:float) -> void:
	get_input()
