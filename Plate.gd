extends Control
class_name Plate


@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var cake_container = $CakeContainer
@onready var panel = $Panel

func _ready():
	_resize()


func _on_resized():
	if collision_shape_2d:
		_resize()


func _resize():
	collision_shape_2d.global_position = global_position + size/2
	collision_shape_2d.shape.size = size


func add_cake(cake):
	cake_container.add_child(cake)
