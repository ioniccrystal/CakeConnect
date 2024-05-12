extends Control


@onready var plate = $MarginContainer/VBoxContainer/Plate
@onready var conveyer = $MarginContainer/VBoxContainer/Conveyer


func _ready():
	cake_generate()


func cake_generate():
	conveyer.add_cake()


func _on_timer_1_timeout():
	cake_generate()

