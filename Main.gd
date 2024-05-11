extends Node2D

var cake_scene = preload("res://Cake.tscn")


@onready var plate = $Background/MarginContainer/VBoxContainer/Plate
@onready var conveyer = $Background/MarginContainer/VBoxContainer/Conveyer


func _ready():
	cake_generate()

func cake_generate():
	var random_cake = cake_scene.instantiate()
	conveyer.add_cake(random_cake)
	random_cake.set_shape(random_cake.random_shape_value)
	
func _on_timer_1_timeout():
	cake_generate()

	



#func init_cake():
	#var cake1 = cake_scene.instantiate()
	#conveyer.add_cake(cake1)
	#cake1.set_shape(Cake.Shape.TRIANGLE)
	#var cake2 = cake_scene.instantiate()
	#conveyer.add_cake(cake2)
	#cake2.set_shape(Cake.Shape.SQUARE)
	#var cake3= cake_scene.instantiate()
	#conveyer.add_cake(cake3)
	#cake3.set_shape(Cake.Shape.DIAMOND)

