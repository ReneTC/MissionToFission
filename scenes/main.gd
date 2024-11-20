extends Node

var screen_size
var atom_scene: PackedScene
@export var number_atoms = 5
@export var atom_speed = 10
@export var atom_mean_lifetime = 100

var neutron_scene = load("res://scenes/neutron.tscn")


func _ready() -> void:
	screen_size = get_viewport().get_size()
	atom_scene = load("res://scenes/atom.tscn")
	for i in range(number_atoms):
		add_atom(i)

func get_square_lattice_point(i) -> Vector2:
	# TODO this should be set by a global file like COLIUM_SIZE and ROW_SIZE that does not depend on screen size.
	var number_rows = int(ceil(sqrt(float(screen_size[1]) / float(screen_size[0]) * number_atoms)))
	var number_columns = int(ceil(number_atoms / number_rows))
	
	
	return Vector2(
			0.1 * screen_size[0] + 0.8 * screen_size[0] / (number_columns - 1) * (i % number_columns),
			0.1 * screen_size[1] + 0.8 * screen_size[1] / (number_rows - 1) * floor(i / number_columns)
		)

func get_random_movement_direction() -> Vector2:
	return Vector2(
			2 * (randf() - 0.5),
			2 * (randf() - 0.5)
		)

func add_atom(i) -> void:
		var atom = atom_scene.instantiate()
		atom.position = get_square_lattice_point(i)
		atom.life_time = 2 * atom_mean_lifetime * randf()
		add_child(atom)


func _input(event) -> void:
	
	# close program on exit
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	# send out neutron on click
	if event is InputEventMouseButton and not event.is_pressed():
		var new_neutron = neutron_scene.instantiate()
		new_neutron.initialize(event.position) 
		add_child(new_neutron) 
