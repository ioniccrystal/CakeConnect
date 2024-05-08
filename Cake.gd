extends Control
class_name  Cake

enum Status {
	FIXED, DRAGGING, IDLE
}
enum Shape {
	SQUARE, TRIANGLE, DIAMOND
}
var status = Status.IDLE
var shape = Shape.SQUARE
var rotating = false
var container_position: Vector2 = Vector2.ZERO
var container_size: Vector2 = Vector2.ZERO
var rotation_speed = PI/6 # 根据蛋糕形状确定

var shape_points = {
	Shape.SQUARE: [Vector2(0, 0), Vector2(50, 0), Vector2(50, 50), Vector2(0, 50)],
	Shape.TRIANGLE: [
		Vector2(25, 0),
		Vector2(50, 43.3),
		Vector2(0, 43.3),
	],
	Shape.DIAMOND: [
		Vector2(25, 0),
		Vector2(50, 43.3),
		Vector2(25, 86.6),
		Vector2(0, 43.3)
	]
}
var highlight_material = preload("res://assets/cake_highlight_border.tres")
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var polygon_2d = $Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_mouse_filter(MOUSE_FILTER_STOP)
	#update_collision_shape()
	connect("resized", Callable(self, "update_collision_shape"))

func set_shape(shape_key):
	shape = shape_key
	var points = shape_points[shape_key]
	polygon_2d.polygon = points
	if shape_key == Shape.DIAMOND:
		size = Vector2(50, 100)
	else:
		size = Vector2(50, 50)
	var shape2D = ConvexPolygonShape2D.new()
	shape2D.set_point_cloud(points)
	collision_shape_2d.shape = shape2D
	collision_shape_2d.position = collision_shape_2d.position
	#rotation_speed = PI / 2 if shape_key == "square" else PI / 3


func draw_outline(color):
	var full_points = shape_points[shape].duplicate()
	full_points.append(shape_points[shape][0])
	draw_polyline(full_points, color, 2.0)
	
func _draw():
	if status == Status.DRAGGING:
		draw_outline(Color.GREEN)
	elif status == Status.IDLE:
		draw_outline(Color.BLUE)
	else:
		draw_outline(Color.TRANSPARENT)
		
func update_collision_shape():
	var shape2D = collision_shape_2d.shape
	if shape2D and shape2D is RectangleShape2D:
		# 设置碰撞形状的尺寸匹配PanelContainer的尺寸
		shape2D.extents = size / 2

func _process(_delta):
	if status == Status.DRAGGING:
		container_position = get_parent().global_position
		container_size = get_parent().size
		# 限定不超出屏幕
		var mouse_pos = get_global_mouse_position()
		var new_position = mouse_pos - size * 0.5
		new_position.x = clamp(new_position.x, container_position.x, container_position.x + container_size.x - size.x)
		new_position.y = clamp(new_position.y, container_position.y, container_position.y + container_size.y - size.y)
		global_position = new_position
		check_snap()


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.button_mask == 1: # and status == Status.IDLE
				status = Status.DRAGGING
				queue_redraw()
				sprite_2d.material = highlight_material
			elif event.button_mask == 0 and status == Status.DRAGGING:
				sprite_2d.material = null
				snap()
				status = Status.FIXED
				queue_redraw()
		elif status == Status.DRAGGING \
			and event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# 处理鼠标滚轮旋转
			var rotate_dir = -1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1
			start_rotate(rotate_dir)

func _input(event):
	if event is InputEventKey and status == Status.DRAGGING:
		if event.pressed:
			if event.keycode == KEY_A:
				start_rotate(-1)
			elif event.keycode == KEY_D:
				start_rotate(1)
				
func start_rotate(rotate_dir):
	if not rotating:
		var end_rotation =  rotation + rotate_dir * rotation_speed
		print(end_rotation)
		var tween = get_tree().create_tween()
		rotating = true
		tween.tween_property(self, "rotation", end_rotation, 0.2)
		tween.tween_callback(on_rotate_finished)
		
func on_rotate_finished():
	rotating = false

var snap_distance = 20.0  # 吸附距离阈值
var min_distance = INF
var best_match = null

func check_snap():
	if status == Status.DRAGGING:
		min_distance = INF
		best_match = null
		# 获取盘子上所有蛋糕
		var cakes = (get_parent().get_parent() as Plate).cakes_on_plate
		for cake in cakes:
			# 获取其他蛋糕和当前蛋糕的polygon
			if cake == self:
				continue
			var cake_poly = get_global_vertices(cake.polygon_2d)
			var this_poly = get_global_vertices(polygon_2d)
			#print('this_poly=', shape, ' position =', this_poly)
			#print('cake_poly=', cake.shape, ' position =', cake_poly)
			# 计算其他蛋糕的每条边和当前蛋糕的每条边之间的距离
			for k in range(cake_poly.size()):
				var seg1_from = cake_poly[k]
				var seg1_to = cake_poly[(k + 1) % cake_poly.size()]

				for l in range(this_poly.size()):
					var seg2_from = this_poly[l]
					var seg2_to = this_poly[(l + 1) % this_poly.size()]
					var direction1 = seg1_to - seg1_from
					var direction2 = seg2_to - seg2_from
					#print(is_parallel(direction1, direction2))
					# 计算距离
					var closest_points = Geometry2D.get_closest_points_between_segments(seg1_from, seg1_to, seg2_from, seg2_to)
					var distance = (closest_points[0]-closest_points[1]).length()
					if distance < min_distance and is_parallel(direction1, direction2):
						# 比较保留最小距离
						min_distance = distance
						best_match = [seg1_from, seg1_to, seg2_from, seg2_to]


func snap():
	print('try snap,min_distance = ', min_distance)
	if min_distance <= snap_distance:
		var segment1 = best_match.slice(0, 2) # 固定蛋糕的线段端点
		var segment2 = best_match.slice(2, 4) # 移动蛋糕的线段端点
		# 计算线段的方向向量
		var dir1 = segment1[1] - segment1[0]
		var dir2 = segment2[1] - segment2[0]
		# 由于线段平行,方向向量应该相同或相反
		var move_direction
		if dir1.dot(dir2) > 0:
			## 方向相同,移动使线段1的端点与线段2的端点重合
			move_direction = segment1[0] - segment2[0]
		else:
			## 方向相反,移动使线段1的端点与线段2的另一端点重合
			move_direction = segment1[0]- segment2[1]
		position += move_direction

# 计算两个向量的外积
func is_parallel(v1: Vector2, v2: Vector2) -> bool:
	# 叉积结果为0表示两向量平行
	return abs(v1.x * v2.y - v1.y * v2.x) < 0.1  # 使用一个小的容差来避免浮点数精度问题


# 计算全局位置
func get_global_vertices(polygon):
	var global_vertices = []
	for vertex in polygon.polygon:
		global_vertices.append(polygon.global_transform.origin + polygon.global_transform.basis_xform(vertex))
	return global_vertices
