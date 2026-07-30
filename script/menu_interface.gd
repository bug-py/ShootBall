extends CanvasLayer
signal play


func _ready() -> void:
	hide()
func start():
	show()



func _on_play_pressed() -> void:
	hide()
	play.emit()
func _on_quit_pressed() -> void:
	get_tree().quit()
