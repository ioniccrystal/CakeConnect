extends Control
class_name Conveyer

var cakes_on_conveyer = []

@onready var cake_container = $CakeContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_cake(cake):
	cake_container.add_child(cake)
	cakes_on_conveyer.append(cake)
	# set a random position
	cake.position = Vector2(randf_range(0, size.x), randf_range(0, size.y))
