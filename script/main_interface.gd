extends CanvasLayer
signal reset



func start():
	$Score.text="0"	
	$Reset.visible=false
func game_over():
	$Reset.visible=true
func update_score(score: int):
	$Score.text=str(score)

func _on_reset_pressed():
	reset.emit()
