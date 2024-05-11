extends Area2D
signal cake_in_trashbin
@onready var HUD = get_node("/root/Main/HUD")
@onready var conveyer = get_node("/root/Main/Background/MarginContainer/VBoxContainer/Conveyer")


func _ready():
	connect("cake_in_trashbin",Callable(HUD,"change_heart"))
	

func _on_area_entered(_area):
	emit_signal("cake_in_trashbin")
