extends Area2D
signal cake_in_trashbin
@onready var HUD = get_node("/root/Main/HUD")
@onready var conveyer = get_node("/root/Main/MarginContainer/VBoxContainer/Conveyer")


func _ready():
	connect("cake_in_trashbin",Callable(HUD,"change_heart"))


func _on_body_entered(cake):
	cake.cake_fade_out()
	emit_signal("cake_in_trashbin")
