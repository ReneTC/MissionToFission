extends Area2D
class_name ControlRod

var height: float = 900
var width: float = 10
var color:Color = Color("444444")
static var speed: float = 50
static var enable_auomatic : bool = true
var direction:float = 0.

# logic to move every second ctrl rod
var even:bool = true
static var move_even = true
static var last_created_even = true

func _ready() -> void:
	# set collisohape to set varables
	var rectangle_shape:Shape2D =  $CollisionShape2D.shape as RectangleShape2D
	rectangle_shape.extents = Vector2(self.width/2., self.height/2.) 
	
	# enable collison check w neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, true)

	# also fast neutrons
	set_collision_mask_value(globals.moderator_neutron_slot, true)
	last_created_even = not last_created_even
	even = last_created_even

func _draw() -> void:
	draw_rect(Rect2(-self.width/2., -self.height/2., self.width, self.height), self.color)


func initialize(pos_to_set:Vector2) -> void:
	position = Vector2(pos_to_set[0], -420)
	
# delete neutron on enter
func _on_body_entered(body: Node2D) -> void:
	body.kill_self()


func _process(delta: float) -> void:
	if (even and move_even) or (not even and not move_even):
		# automatic control here 
		if enable_auomatic:
			# move up 
			if GameRunner.neutron_counter > GameRunner.goal:
				direction = 1
			elif GameRunner.neutron_counter < GameRunner.goal:
				direction = -1
			
			# move down
		# TODO these should be static variables and only be changed upon CTRL rod creation
		var min_height = -420
		var max_height = GameRunner.y_row_build * GameRunner.margin + min_height
		position.y = clampf(position.y+direction*delta*speed, min_height, max_height)
		
		# switch 
		if move_even and position.y == max_height:
			move_even = not move_even

		elif not move_even and position.y == min_height:
			move_even = not move_even
			
func get_input() -> void:
	if Input.is_action_just_pressed("w") or Input.is_action_just_pressed("s"):
			enable_auomatic = false
			$looper.play()

	if Input.is_action_just_released("w") or Input.is_action_just_released("s"):
		enable_auomatic = false
		direction = 0
		$looper.stop()
		$sound_rod_end.play()
		
	if Input.is_action_pressed("s"):
		direction = 1
	if Input.is_action_pressed("w"):
		direction = -1


func _physics_process(_delta:float) -> void:
	get_input()
