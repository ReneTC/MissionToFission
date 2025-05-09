extends Area2D
class_name ControlRod

var width: float = 10
var color:Color = Color("444444")
static var speed: float = 0  # set in globals
static var enable_auomatic : bool = true # set in globals
var direction:float = 0.

# logic to move every second ctrl rod
var even:bool = true
static var move_even:bool = false # set in globals
static var last_created_even:bool = true # set in globals

static var min_height: float = 200
static var max_height: float = - 420
static var rod_height: float = 900

static var _registered_nodes: Array = []
var rectangle_shape:Shape2D =  null

func _ready() -> void:
	# set collisohape to set varables
	rectangle_shape = $CollisionShape2D.shape as RectangleShape2D
	rectangle_shape.extents = Vector2(self.width/2., self.rod_height/2.) 
	
	# enable collison check w neutrons
	set_collision_mask_value(globals.neutrol_collide_slot, true)
	# also fast neutrons
	set_collision_mask_value(globals.moderator_neutron_slot, true)
	
	# logic for moving unevenly up and down
	last_created_even = not last_created_even
	even = last_created_even
	# move_even = not move_even
	
	# logic to n
	add_to_group("ctrl_rods")
	_registered_nodes.append(self)
	update_control_rods()
	
	# force all to up initted to max y height
	# if size bigger than to, take eve nidnex and get that position 
	# also modify the collision shape 
	if len(_registered_nodes) > 2:
		position.y = _registered_nodes[int(last_created_even)].position.y
	else:
		position.y = max_height
	
func _draw() -> void:
	draw_rect(Rect2(-self.width/2., -self.rod_height/2., self.width, self.rod_height), self.color)
	# set collisohape to set varables
	rectangle_shape.extents = Vector2(self.width/2., self.rod_height/2.) 
	

func initialize(pos_to_set:Vector2) -> void:
	position = Vector2(pos_to_set)
	
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
		
	if Input.is_action_pressed("s") or Input.is_action_pressed("ui_up"):
		direction = 1
	if Input.is_action_pressed("w") or Input.is_action_pressed("ui_down"):
		direction = -1

		
func _physics_process(_delta:float) -> void:
	get_input()
	
static func update_control_rods() -> void:
	rod_height = GameRunner.y_row_build * GameRunner.margin 
	min_height = -rod_height/2 + GameRunner.margin/2
	max_height = rod_height/2 + GameRunner.margin/2
	
	# que redraw
	#for ctrlrod: CanvasItem in _registered_nodes:
		#ctrlrod.position.y = clampf(ctrlrod.position.y, min_height, max_height)
		#ctrlrod.queue_redraw()
		
