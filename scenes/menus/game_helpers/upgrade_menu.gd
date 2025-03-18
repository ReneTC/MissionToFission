extends CanvasLayer

@export var game_runner: GameRunner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add sounds to button
	$UiButtonSound.connect_button_ui()
	hide()
	
func pop_in_select_actions() -> void:
	'''
	- generate 3 random actions
	- pause game 
	- pop in
	 
	'''
	print("pop in select actions")
	show()



	
