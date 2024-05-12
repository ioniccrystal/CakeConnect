extends Area2D
class_name PointArea

var angle:int
@onready var label = $Label
@onready var cake = get_parent()
var point_together = []

func set_label(text):
	label.text = text
	label.rotation = -cake.rotation
	label.show()
	$CPUParticles2D.emitting = true
	var tween = create_tween()
	tween.tween_property(label,"scale",Vector2(2,2),0.5)
	await get_tree().create_timer(0.3).timeout
	#蛋糕淡出需要0.2秒，还剩0.3秒等一下
	boom()

func boom():
	#把兄弟们先鲨了
	for item in point_together:
		item.cake.cake_fade_out()
	#把自己也鲨了
	cake.cake_fade_out()

func _on_area_entered(area):
	point_together.append(area)
	#print("point together!"+str(area)+str(point_together))


func _on_area_exited(area):
	point_together.erase(area)
	#print("point leaves..."+str(area)+str(point_together))
