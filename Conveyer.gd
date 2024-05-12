extends Control
class_name Conveyer

var cake_scene = preload("res://Cake.tscn")

@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var cake_container = $CakeContainer
@onready var main = get_node_or_null("/root/Main/")

func _ready():
	_resize()


func _resize():
	collision_shape_2d.global_position = global_position + size/2
	collision_shape_2d.shape.size = size


func _on_resized():
	if collision_shape_2d:
		_resize()


func add_cake():
	for oldcake in cake_container.get_children():
		if oldcake.status != oldcake.Status.DRAGGING:
			var new_position = Vector2(145,0)
			oldcake.move_and_collide(new_position)
			await get_tree().create_timer(0.05).timeout
	#延时一秒再放下新蛋糕
	await get_tree().create_timer(1.0).timeout
	var cake = cake_scene.instantiate()
	cake_container.add_child(cake)
	cake.set_shape(cake.random_shape_value)
