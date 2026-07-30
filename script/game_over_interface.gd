extends CanvasLayer
signal reset
signal home
func _ready()->void:
	hide()
func start(score):
	$score.text=str(score)
	show()


func _on_home_pressed() -> void:
	hide()
	home.emit()
	
	
func _on_reset_pressed() -> void:
	hide()
	reset.emit()
	
