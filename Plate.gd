extends PanelContainer
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var plate = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	update_collision_shape()
	$CakeContainer.size = size
	print(size, $CakeContainer.size)
	# 连接信号以便在大小改变时更新形状
	plate.connect("resized", Callable(self, "update_collision_shape"))
	
func update_collision_shape():
	var shape = collision_shape_2d.shape
	if shape and shape is RectangleShape2D:
		# 设置碰撞形状的尺寸匹配PanelContainer的尺寸
		shape.extents = size / 2
	$CakeContainer.size = size
	print(size, $CakeContainer.size)

func add_cake(cake):
	$CakeContainer.add_child(cake)
	#$CakeContainer.move_child(new_child, get_child_count() - 1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
