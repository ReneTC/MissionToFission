extends MarginContainer

@export var current_value: int = 0
var min_value: int  = 0
var max_value: int  = 1000
var meter_angle: float = 0.0 
var green_angles_hift: float = 0.0

func set_current_value(new_value: int) -> void:
	current_value = new_value
	meter_angle = remap(current_value, min_value, max_value, 0, 180)
	# calc new angle for speedmetor. c
	queue_redraw()


func _draw() -> void:
	$TextureProgressBar/currentVal.text = str(current_value)
	$TextureProgressBar/Indi.rotation = deg_to_rad(meter_angle - 150)
	if GameRunner.game_mode_enabled:
		# calc accepted range
		$TextureProgressBar.value = GameRunner.margin_error * 2
		# calc shift
		green_angles_hift = remap(GameRunner.goal - GameRunner.margin_error, 0, 1000, 0, 180)
		$TextureProgressBar.radial_initial_angle = 270+green_angles_hift
		# $TextureProgressBar/Label.rotation_degrees = 270+green_angles_hift+23
		$TextureProgressBar/Label.text = "Goal: "+str(GameRunner.goal)+" ± " + str(GameRunner.margin_error)
	else:
		$TextureProgressBar.value = 0.0
