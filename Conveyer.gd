extends Control
class_name Conveyer

var cakes_on_conveyer = []
var temporary_cake_containers = []


func _ready():
	connect("resized", Callable(self, "update_collision_shape"))


func add_cake(cake):
	#给每个随机生成的蛋糕生成一个control类型的container来装蛋糕（虽然好像也许可以直接加蛋糕……
	var new_container = Control.new()
	new_container.name = "TemporaryCakeContainer"
	new_container.position = Vector2(0,0)
	temporary_cake_containers.append(new_container)
	add_child(new_container)
	new_container.add_child(cake)
	cakes_on_conveyer.append(cake)


func _on_child_entered_tree(node):
	var new_position = Vector2(60,0)
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",new_position,0.4)

