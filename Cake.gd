extends RigidBody2D
class_name Cake
#zhufree的部分
enum Status {
	FIXED, DRAGGING, IDLE
}
enum Shape {
	SQUARE, TRIANGLE, DIAMOND
}
var status = Status.IDLE
var shape = Shape.SQUARE
var rotating = false
#var container_position: Vector2 = Vector2.ZERO
#var container_size: Vector2 = Vector2.ZERO
var rotation_speed = PI/6 # 根据蛋糕形状确定
var plate = null

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

#ionic的部分
var points = []
var cake_bottom = []
@onready var HUD = get_node("/root/Main/HUD")
var point_area = preload("res://PointArea.tscn")
var point_areas = []
var shape_points_angle = {
	Shape.SQUARE: [90,90,90,90],
	Shape.TRIANGLE: [60,60,60],
	Shape.DIAMOND: [60,120,60,120]
	}

#瓜的部分
var shape_values:Array = [Shape.SQUARE,Shape.TRIANGLE,Shape.DIAMOND]
var random_index = randi()%3
var random_shape_value = shape_values[random_index]

#var highlight_material = preload("res://assets/cake_highlight_border.tres")
@onready var collision_shape_2d = find_child("CollisionShape2D")
@onready var polygon_2d = find_child("Polygon2D")


func _ready():
	plate = get_node_or_null("/root/Main/MarginContainer/VBoxContainer/Plate") as Plate  # 根据你的场景树结构修改路径

func set_shape(shape_key):
	shape = shape_key
	points = shape_points[shape_key]
	#找质心
	var centroid = Vector2(0,0)
	for point in points:
		centroid += point
	centroid /= points.size()
	var new_points = []
	for point in points:
		point = point - centroid
		new_points.append(point)
	points = new_points
	var shape2D = ConvexPolygonShape2D.new()
	polygon_2d.polygon = points
	shape2D.set_point_cloud(points)
	collision_shape_2d.shape = shape2D
	collision_shape_2d.position = collision_shape_2d.position
	collision_shape_2d.scale = Vector2(0.98,0.98)#稍微小一点不然挤不进去
	#做蛋糕层
	_make_cake()
	#给每个点贴上标签
	_set_point_areas()
	

func in_plate():
	return get_parent().get_parent() is Plate

func draw_outline(color):
	var full_points = points.duplicate()
	full_points.append(points[0])
	draw_polyline(full_points, color, 4.0)
	
func _draw():
	if status == Status.DRAGGING:
		draw_outline(Color.GREEN)
	elif status == Status.IDLE:
		draw_outline(Color.WHITE)
	else:
		draw_outline(Color.TRANSPARENT)

func _physics_process(_delta):
	if status == Status.DRAGGING:
		var mouse_pos = get_global_mouse_position()
		var velocity = mouse_pos - global_position
		move_and_collide(velocity)
	for i in cake_bottom.size():
		cake_bottom[i].global_position = polygon_2d.global_position + Vector2(0,(i+1)*2)

func try_to_transfer_node():
	if plate.area_2d.overlaps_body(self):
		var old_global = global_position
		get_parent().remove_child(self)
		plate.add_cake(self)
		# 调整本地坐标以适应新的父节点
		global_position = old_global
	else:#扔下去了扣分
		cake_fade_out()
		HUD.change_heart()


func cake_fade_out():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self,"modulate",Color.TRANSPARENT,0.2)
	tween.tween_property(self,"scale",Vector2(0.5,0.5),0.2)
	await tween.finished
	queue_free()

#ionic：感觉滚轮已经很方便了这个要不就算了
#func _input(event):
	#if event is InputEventKey and status == Status.DRAGGING:
		#if event.pressed:
			#if event.keycode == KEY_A:
				#start_rotate(-1)
			#elif event.keycode == KEY_D:
				#start_rotate(1)

#zhufree旋转代码
func start_rotate(rotate_dir):
	if not rotating:
		var end_rotation =  rotation + rotate_dir * rotation_speed
		var tween = get_tree().create_tween()
		rotating = true
		tween.tween_property(self, "rotation", end_rotation, 0.2)
		tween.tween_callback(on_rotate_finished)
		
func on_rotate_finished():
	rotating = false

var snap_distance = 20.0  # 吸附距离阈值
var min_distance = INF
var best_match = null

#zhufree贴贴代码
func check_snap():
	if status == Status.DRAGGING:
		min_distance = INF
		best_match = null
		# 获取盘子上所有蛋糕
		var cakes = plate.cake_container.get_children()
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

#zhufree贴贴代码
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
		move_and_collide(move_direction)


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


#这里只管旋转了
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton :
		#print("moving " + str(self))
		if status == Status.DRAGGING and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# 处理鼠标滚轮旋转
			start_rotate(-1)
		if status == Status.DRAGGING and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			start_rotate(1)


#ionic被鼠标传递整不会了！贴了个按钮在上面！
func _on_texture_button_button_down():
	if status != Status.FIXED:
		status = Status.DRAGGING
		#改碰撞层
		set_collision_layer_value(1,false)
		set_collision_layer_value(2,true)
		#显示在最前
		z_index = 100


func _on_texture_button_button_up():
	if status == Status.DRAGGING:
		#回到原来的碰撞层
		set_collision_layer_value(2,false)
		set_collision_layer_value(1,true)
		#放到盘子上
		try_to_transfer_node()
		#贴贴
		check_snap()
		snap()
		status = Status.FIXED
		#不许再动了
		freeze = true
		$TextureButton.disabled = true
		#问问有没有点满足360度
		ask_points()

#ionic蛋糕层效果
func _make_cake():
	for i in range(9):
		var new_polygon = polygon_2d.duplicate()
		add_child(new_polygon)
		new_polygon.global_position = polygon_2d.global_position + Vector2(0,(i+1)*2)
		new_polygon.color = Color.PINK
		if i > 3 and i < 6:
			new_polygon.color = Color.ROSY_BROWN
		new_polygon.z_index = - (i + 1)
		cake_bottom.append(new_polygon)
	queue_redraw()

#ionic贴角点标签
func _set_point_areas():
	for n in points.size():
		var new_point_area = point_area.instantiate()
		add_child(new_point_area)
		new_point_area.position = points[n]
		new_point_area.angle = shape_points_angle[shape][n]
		point_areas.append(new_point_area)

#ionic问问角点有没有360的
func ask_points():
	await get_tree().create_timer(0.1).timeout
	#这步写的很不好，我知道要等它在盘子上加载完，但不知道应该用什么信号判断
	#盘子的add_child也需要再_ready()一次吗？好像又不需要。不懂了摆了，用个秒表延时一点算了
	var connected_points = []
	var score = 0
	var times = 0#如果一个要消除的点没有，倍率就是0
	#遍历每个点
	for area in point_areas:
		var angle_sum = area.angle
		print(area.point_together)
		for point in area.point_together:
			angle_sum += point.angle
		if angle_sum == 360 :#如果满足360度
			connected_points.append(area)#把这个点存入connected
			area.set_label("x"+str(connected_points.size()))
	await get_tree().create_timer(0.3).timeout#略等一下动画
	#消除，并计算消除了多少个块
	if connected_points != []:
		times = connected_points.size()#计算倍数
		for point in connected_points:
			for point_together in point.point_together:#遍历需要消除的点相邻的点
				score += 100
				point_together.cake.cake_fade_out()
		score += 100 #自己也需要消除
		cake_fade_out()
	#总得分
	score *= times
	HUD.change_score(score)
