extends Node2D

var cake_scene = preload("res://Cake.tscn")

@onready var plate = $ColorRect/MarginContainer/VBoxContainer/Plate
@onready var conveyer_container = $ColorRect/MarginContainer/VBoxContainer/ConveyerContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	init_cake()

func init_cake():
	var cake = cake_scene.instantiate()
	plate.add_cake(cake)
	cake.set_shape("square")
