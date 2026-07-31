extends CanvasLayer


func _ready()->void:
	hide()

func start(init_score:int,init_life:int):
	update_score(init_score)
	update_life(init_life)
	$Score/InitAnim.start()
	$HealthBar/InitAnim.start()
	show()
func stop():
	hide()
func update_score(score: int):
	$Score.text=str(score)
func update_life(life:int):
	for i in range(0,7):
		var heart:TextureRect=get_node("HealthBar/life_"+str(i))
		heart.visible=i<life
	
