extends Node2D

var cake_scene = preload("res://Cake.tscn")
var cake3_scene = preload("res://Cake3.tscn")
@onready var plate = $Background/MarginContainer/VBoxContainer/Plate
@onready var conveyer = $Background/MarginContainer/VBoxContainer/Conveyer

var current_cake = []
var dragging = false
# Called when the node enters the scene tree for the first time.
func _ready():
	init_cake()

func init_cake():
	var cake1 = cake_scene.instantiate()
	conveyer.add_cake(cake1)
	cake1.set_shape(Cake.Shape.TRIANGLE)
	var cake2 = cake_scene.instantiate()
	conveyer.add_cake(cake2)
	cake2.set_shape(Cake.Shape.SQUARE)
	var cake3= cake_scene.instantiate()
	conveyer.add_cake(cake3)
	cake3.set_shape(Cake.Shape.DIAMOND)
	var cake4= cake3_scene.instantiate()
	conveyer.add_cake(cake4)
	cake4.set_shape(Cake2.Shape.DIAMOND)
	cake4.mouse_entered.connect(_on_cake_mouse_entered.bind(cake4))
	cake4.mouse_exited.connect(_on_cake_mouse_exited.bind(cake4))
	var cake5= cake3_scene.instantiate()
	conveyer.add_cake(cake5)
	cake5.set_shape(Cake2.Shape.DIAMOND)
	cake5.mouse_entered.connect(_on_cake_mouse_entered.bind(cake5))
	cake5.mouse_exited.connect(_on_cake_mouse_exited.bind(cake5))

func _input(event):
	if event is InputEventMouseButton and current_cake!=[]:
		print("moving " + str(current_cake))
		if event.button_index == 1:
			print(event.button_mask)
			if event.button_mask == 1: # and status == Status.IDLE
				current_cake[0].status = Cake3.Status.DRAGGING
				dragging = true
				z_index = 100
				#queue_redraw()
			elif event.button_mask == 0 and current_cake[0].status == Cake3.Status.DRAGGING:
				#if not in_plate():
					#try_to_transfer_node()
				current_cake[0].check_snap()
				current_cake[0].snap()
				current_cake[0].status = Cake3.Status.FIXED
				dragging = false
				#queue_redraw()
		elif current_cake[0].status == Cake3.Status.DRAGGING \
			and event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# 处理鼠标滚轮旋转
			var rotate_dir = -1 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1
			current_cake[0].start_rotate(rotate_dir)

func _on_cake_mouse_entered(cake:Cake3):
	if !dragging:
		current_cake.append(cake)
		print(current_cake)

func _on_cake_mouse_exited(cake:Cake3):
	if !dragging:
		current_cake.erase(cake)
		print(current_cake)
