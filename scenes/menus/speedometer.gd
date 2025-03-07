extends MarginContainer

@export var current_value: int = 0
var min_value: int  = 0
var max_value: int  = 1000
var meter_angle: float = 0 # 150 deg is 0 pos	

func set_current_value(new_value: int) -> void:
	current_value = new_value
	meter_angle = remap(current_value, min_value, max_value, 0, 180)
	# calc new angle for speedmetor. c
	queue_redraw()


func _draw() -> void:
	$TextureProgressBar/currentVal.text = str(current_value)
	$TextureProgressBar/Indi.rotation = deg_to_rad(meter_angle - 150)
