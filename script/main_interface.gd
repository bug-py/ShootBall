extends CanvasLayer
signal reset



func start():
	$Score.text="0"	
	update_life(5)
	$Reset.visible=false
func game_over():
	$Reset.visible=true
func update_score(score: int):
	$Score.text=str(score)
func update_life(life:int):
	for i in range(0,7):
		var heart:TextureRect=get_node("HealthBar/life_"+str(i))
		heart.visible=i<life
	

func _on_reset_pressed():
	reset.emit()
