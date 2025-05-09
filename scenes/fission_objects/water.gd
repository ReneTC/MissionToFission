extends Area2D
class_name Water

var height: float = 60
var width: float = 60
var cold_color:Color = Color("DCEEFF")
var hot_color:Color = Color("FF4949")
var gone_color:Color = Color("FFFFFF")
var speed: float = 10

static var water_absorb_chance: float = 0.05
static var cool_of_speed:float = 10
var temp: float = 0.


func _ready() -> void:
	# set collisohape to set varables
	var rectangle_shape:RectangleShape2D =  $CollisionShape2D.shape as RectangleShape2D
	rectangle_shape.extents = Vector2(self.width/2., self.height/2.) 
	
	# enable collison check w neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, true)
	set_collision_mask_value(globals.moderator_neutron_slot, true)
	


func _draw() -> void:
	var color_draw:Color = self.gone_color
	if self.temp < 100:
		color_draw = self.cold_color.lerp(self.hot_color, self.temp/100)
	draw_rect(Rect2(-self.width/2., -self.height/2., self.width, self.height), color_draw)


func initialize(pos_to_set:Vector2) -> void:
	position = Vector2(pos_to_set[0], pos_to_set[1])
	

func _process(_delta:float) -> void:
	self.temp = clampf(self.temp - (self.cool_of_speed*_delta), 0, 100000000)
	# consider only redraw on temot change 
	queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	self.temp += 5
	if self.temp < 100:
		if randf() < water_absorb_chance:
			body.kill_self_deflate()
		# let water moderate
		if Neutron.enable_moderation and body.is_fast:
			body.current_speed *= 0.95
			body.linear_velocity = body.linear_velocity.normalized() * body.current_speed
			# stop collidng width moderator:
			if body.current_speed < 100:
				body.is_fast = false
			body.queue_redraw()
			
			
