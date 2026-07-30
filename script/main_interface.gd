extends CanvasLayer


func _ready()->void:
	hide()

func start():
	$Score.text="0"	
	update_life(5)
	show()
func stop():
	hide()
func update_score(score: int):
	$Score.text=str(score)
func update_life(life:int):
	for i in range(0,7):
		var heart:TextureRect=get_node("HealthBar/life_"+str(i))
		heart.visible=i<life
	
