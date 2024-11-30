extends Node2D



func get_and_show_dia(path):
	DialogueManager.show_dialogue_balloon(load("res://scenes/maps/tut_dialogue/"+ path +".dialogue"))
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_and_show_dia("tutorial")


# procces get satus of paused
# if state pause: hide dialoage.
