extends Node2D
@onready var plate = $ColorRect/MarginContainer/VBoxContainer/Plate
@onready var conveyer_container = $ColorRect/MarginContainer/VBoxContainer/ConveyerContainer

var cake_scene = preload("res://Cake.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	init_cake()

func init_cake():
	var cake = cake_scene.instantiate()
	plate.add_cake(cake)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
