extends CanvasLayer

func update_hud(score_timer:float, countdown_till_upgrade:float, countdown_till_loss:float, upgrade_time_left:float, loss_time_left:float) -> void:
	$GameScore/MarginContainer/VBoxContainer2/Button.text = "Survive: %.1f" % score_timer

	$"GameScore/MarginContainer/VBoxContainer2/upgrade-bar".max_value = countdown_till_upgrade
	$"GameScore/MarginContainer/VBoxContainer2/upgrade-bar".value = upgrade_time_left
	$"GameScore/MarginContainer/VBoxContainer2/loose-bar".max_value = countdown_till_loss
	$"GameScore/MarginContainer/VBoxContainer2/loose-bar".value = loss_time_left
