extends Control
class_name Conveyer

var cakes_on_conveyer = []

@onready var cake_container = $CakeContainer
@onready var nine_patch_rect = $NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("resized", Callable(self, "update_collision_shape"))

func update_collision_shape():
	nine_patch_rect.size = size
	
func add_cake(cake):
	cake_container.add_child(cake)
	cakes_on_conveyer.append(cake)
	# set a random position
	cake.position = Vector2(randf_range(0, size.x), randf_range(0, size.y))
