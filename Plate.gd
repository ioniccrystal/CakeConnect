extends Control
class_name Plate

var cakes_on_plate = []

@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	update_collision_shape()
	$CakeContainer.size = size
	connect("resized", Callable(self, "update_collision_shape"))
	
func update_collision_shape():
	var shape = collision_shape_2d.shape
	if shape and shape is RectangleShape2D:
		shape.extents = size / 2
	collision_shape_2d.position = size/2
	$CakeContainer.size = size

func add_cake(cake):
	cakes_on_plate.append(cake)
