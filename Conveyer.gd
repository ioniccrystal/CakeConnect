extends Control
class_name Conveyer

var cakes_on_conveyer = []
@onready var container = $CakeContainer

func _ready():
	connect("resized", Callable(self, "update_collision_shape"))


func add_cake(cake):
	add_child(cake)
	cakes_on_conveyer.append(cake)
	for container in temporary_cake_containers:
		if container.get_child_count()==0:
			temporary_cake_containers.erase(container)
			container.call_deferred("free")

func _on_child_entered_tree(node):
	if node.is_in_group("cake"):
		for cake in cakes_on_conveyer:
			var new_position = Vector2(100,0)
			cake.move_and_collide(new_position)

=======
	var new_position = Vector2(60,0)
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",new_position,0.4)
>>>>>>> .merge_file_YUk9rG
