extends CanvasLayer

@export var game_runner: GameRunner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add sounds to button
	$UiButtonSound.connect_button_ui()

func _on_game_runner_toggle_game_paused(is_paused:bool) -> void:
	if is_paused:
		show()
		animate_in()
		
	else:
		hide()
		animate_out()

func animate_in() -> void:
	$fly_in_sound.play()

	
func animate_out() -> void:
	$fly_in_sound.play()

	
