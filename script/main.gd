extends Node2D


var screen_size:Vector2
var score:int 
var life :int


func update_score(value):
	score+=value
	$MainInterface.update_score(score)
	$Spawner.update_score(score)
func _ready() -> void:
	screen_size=get_viewport_rect().size
	new_game()


func new_game():
	score=0
	life=5

	$Cursor.start($StartCursor.position)
	$MainInterface.start()
	$Spawner.start()
	
	
func game_over():
	life-=1
	$MainInterface.update_life(life)
	if life==0 :
		$Cursor.stop()
		update_score($Spawner.clear_screen())
		$Spawner.stop()
		$MainInterface.game_over()

func _on_cursor_shoot(collision:Array[Node2D]) -> void:
	for node in collision:
		if node.is_in_group("ball"):
			
			if node.stars_ball:
				life=min(life+1,5)
				$MainInterface.update_life(life)
				update_score($Spawner.clear_screen())
			else:
				node.destroy()
				update_score(1)
		if node.is_in_group("bomb"):
			node.destroy()
			game_over()

	
func _on_main_interface_reset() -> void:
	new_game()
