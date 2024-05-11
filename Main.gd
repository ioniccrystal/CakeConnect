extends Control

var cake_scene = preload("res://Cake3.tscn")
var current_cake = []
var dragging = false

@onready var plate = $MarginContainer/VBoxContainer/Plate
@onready var conveyer = $MarginContainer/VBoxContainer/Conveyer


func _ready():
	cake_generate()

func cake_generate():
	var random_cake = cake_scene.instantiate()
	conveyer.add_cake(random_cake)
	random_cake.set_shape(random_cake.random_shape_value)
	random_cake.mouse_shape_entered.connect(_on_cake_mouse_entered.bind(random_cake))
	random_cake.mouse_shape_exited.connect(_on_cake_mouse_exited.bind(random_cake))
func _on_timer_1_timeout():
	cake_generate()

	
func _input(event):
	if event is InputEventMouseButton and current_cake!=[]:
		print("moving " + str(current_cake))
		if event.button_index == 1:
			print(event.button_mask)
			if event.button_mask == 1: # and status == Status.IDLE
				current_cake[0].status = Cake3.Status.DRAGGING
				dragging = true
				z_index = 100
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

func _on_cake_mouse_entered(_shape,cake:Cake3):
	if !dragging:
		current_cake.append(cake)
		print(current_cake)

func _on_cake_mouse_exited(_shape,cake:Cake3):
	if !dragging:
		current_cake.erase(cake)
		print(current_cake)
