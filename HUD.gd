extends CanvasLayer

@onready var heart = $Heart
var current_heart:int
@onready var score = $Score
var current_score:int

func _ready():
	current_heart = 5
	update_heart_num()
	pass
	
func update_heart_num():
	heart.update_heart(current_heart)
	print(current_heart)
	pass
	
func change_heart():
	current_heart = current_heart-1
	update_heart_num()

func change_score(n):
	current_score += n
	score.text = str(current_score)
