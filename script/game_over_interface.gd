extends CanvasLayer
signal reset
signal home
func _ready()->void:
	hide()
func start(score):
	$text/InitAnim.start()
	$score/InitAnim.start()
	$home/InitAnim.start()
	$reset/InitAnim.start()
	$home/HoverAnim.start()
	$reset/HoverAnim.start()
	
	$score.text=str(score)
	show()


func _on_home_pressed() -> void:
	$home/HoverAnim.stop()
	$reset/HoverAnim.stop()
	hide()
	home.emit()
	
	
func _on_reset_pressed() -> void:
	hide()
	reset.emit()
	
