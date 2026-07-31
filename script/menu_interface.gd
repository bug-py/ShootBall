extends CanvasLayer

signal play

func _ready() -> void:
	hide()
func start():
	$Title/InitAnim.start()
	$Play/InitAnim.start()
	$Quit/InitAnim.start()
	$Play/HoverAnim.start()
	$Quit/HoverAnim.start()
	show()

func _on_play_pressed() -> void:
	hide()
	$Play/HoverAnim.stop()
	$Quit/HoverAnim.stop()
	play.emit()
func _on_quit_pressed() -> void:
	get_tree().quit()
