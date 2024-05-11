extends CanvasLayer

@onready var heart = $Heart
var current_heart:int


func _ready():
	current_heart = 5
	update_heart_num()
	pass
	
func update_heart_num():
	heart.update_heart(current_heart)
	pass
	
func change_heart():
	current_heart = current_heart-1
	update_heart_num()


