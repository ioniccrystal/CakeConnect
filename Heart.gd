extends HBoxContainer

var heart_full = preload("res://assets/heart1/heart_full.png")
var heart_hollow = preload("res://assets/heart1/heart_hollow.png")


func update_heart(value):
	for i in self.get_child_count():
		if i < value:
			get_child(i).texture = heart_full
		else:
			get_child(i).texture = heart_hollow
 
