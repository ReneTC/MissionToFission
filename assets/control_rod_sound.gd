extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("q") or Input.is_action_just_pressed("e"):
		$looper.play()

	if Input.is_action_just_released("q") or Input.is_action_just_released("e"):
		$looper.stop()
		$sound_rod_end.play()
