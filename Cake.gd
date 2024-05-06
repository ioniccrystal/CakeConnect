extends PanelContainer

var dragging = false
var rotating = false
var container_position: Vector2 = Vector2.ZERO
var container_size: Vector2 = Vector2.ZERO

@onready var cake = $"."
@onready var collision_shape_2d = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_mouse_filter(MOUSE_FILTER_STOP)
	#update_collision_shape()
	# 大小改变时更新形状
	connect("resized", Callable(self, "update_collision_shape"))
	
func update_collision_shape():
	var shape = collision_shape_2d.shape
	if shape and shape is RectangleShape2D:
		# 设置碰撞形状的尺寸匹配PanelContainer的尺寸
		shape.extents = size / 2

func _process(_delta):
	if dragging:
		container_position = get_parent().global_position
		container_size = get_parent().size
		# 限定不超出屏幕
		var mouse_pos = get_global_mouse_position()
		var new_position = mouse_pos - size * 0.5
		new_position.x = clamp(new_position.x, container_position.x, container_position.x + container_size.x - size.x)
		new_position.y = clamp(new_position.y, container_position.y, container_position.y + container_size.y - size.y)
		global_position = new_position

var rotation_speed = PI/2 # 根据蛋糕形状确定

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.button_mask == 1:
				dragging = true
			elif event.button_mask == 0:
				dragging = false
		elif dragging and event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# 处理鼠标滚轮旋转
			var rotate_dir = -1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1
			start_rotate(rotate_dir)

func _input(event):
	if dragging and event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_A:
				start_rotate(-1)
			elif event.keycode == KEY_D:
				start_rotate(1)
				
func start_rotate(rotate_dir):
	if not rotating:
		var end_rotation =  rotation + rotate_dir * rotation_speed	
		var tween = get_tree().create_tween()
		rotating = true
		tween.tween_property(self, "rotation", end_rotation, 0.2)
		tween.tween_callback(finish_rotate)
		
func finish_rotate():
	rotating = false
