extends Area2D
class_name Water

var height: float = 30
var width: float = 30
var cold_color:Color = Color("DCEEFF")
var hot_color:Color = Color("FF4949")
var gone_color:Color = Color("FFFFFF")
var speed: float = 10

var temp: float = 0.

func _ready() -> void:
	# set collisohape to set varables
	var rectangle_shape =  $CollisionShape2D.shape as RectangleShape2D
	rectangle_shape.extents = Vector2(self.width/2., self.height/2.) 
	
	# enable collison check w neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, true)


func _draw():
	var color_draw = null
	if self.temp > 100:
		color_draw = self.gone_color
	else:
		color_draw = self.cold_color.lerp(self.hot_color, self.temp/100)
	draw_rect(Rect2(-self.width/2., -self.height/2., self.width, self.height), color_draw)


func initialize(pos_to_set):
	
	position = Vector2(pos_to_set[0], pos_to_set[1])
	
	
func _process(_delta):
	if Engine.get_process_frames() % 30 == 0:
		queue_redraw()
		


func _on_body_entered(body: Node2D) -> void:
	self.temp += 1
