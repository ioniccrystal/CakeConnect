extends Control
class_name Conveyer

var cakes_on_conveyer = []
@onready var container = $CakeContainer

func _ready():
	connect("resized", Callable(self, "update_collision_shape"))


func add_cake(cake):
	add_child(cake)
	cakes_on_conveyer.append(cake)

func _on_child_entered_tree(node):
	if node.is_in_group("cake"):
		for cake in cakes_on_conveyer:
			var new_position = Vector2(100,0)
			cake.move_and_collide(new_position)

