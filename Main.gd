extends Node2D

var cake_scene = preload("res://Cake.tscn")

@onready var plate = $ColorRect/MarginContainer/VBoxContainer/Plate
@onready var conveyer = $ColorRect/MarginContainer/VBoxContainer/Conveyer

# Called when the node enters the scene tree for the first time.
func _ready():
	init_cake()

func init_cake():
	var cake1 = cake_scene.instantiate()
	conveyer.add_cake(cake1)
	cake1.set_shape(Cake.Shape.TRIANGLE)
	var cake2 = cake_scene.instantiate()
	conveyer.add_cake(cake2)
	cake2.set_shape(Cake.Shape.SQUARE)
	var cake3= cake_scene.instantiate()
	conveyer.add_cake(cake3)
	cake3.set_shape(Cake.Shape.DIAMOND)
