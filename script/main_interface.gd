extends CanvasLayer
signal reset



func start():
	$Score.text="0"	
	$Life.text="5"
	$Reset.visible=false
func game_over():
	$Reset.visible=true
func update_score(score: int):
	$Score.text=str(score)
func update_life(life:int):
	$Life.text=str(life)

func _on_reset_pressed():
	reset.emit()
