extends Node2D

func fade_in() -> void:
	$CanvasLayer/ColorRect.color = Color(1, 1, 1, 0)
	$CanvasLayer/ColorRect.z_index = 10
	# tween to opacity 1
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($CanvasLayer/ColorRect, "color", Color(1, 1, 1, 1), 0.8)
	
	
func fade_out() -> void:
	$CanvasLayer/ColorRect.color = Color(1, 1, 1, 1)
	$CanvasLayer/ColorRect.z_index = 10
	# tween to opacity 1
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EaseType.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_CUBIC)
	tween.tween_property($CanvasLayer/ColorRect, "color", Color(1, 1, 1, 0), 0.8)
	$CanvasLayer/ColorRect.z_index = -1
