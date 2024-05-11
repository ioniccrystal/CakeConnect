extends Area2D
#signal cake_in_trashbin
@onready var HUD = get_node("/root/Main/HUD")
@onready var conveyer = get_node("/root/Main/MarginContainer/VBoxContainer/Conveyer")


func _ready():
	connect("body_entered",Callable(HUD,"change_heart"))
	
#
#func _on_area_entered(area):
	#emit_signal("cake_in_trashbin")
