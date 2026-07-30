extends Node2D


var screen_size:Vector2
var score:int 
var life :int



func _ready() -> void:
	screen_size=get_viewport_rect().size
	$Menu.start()

func update_score(new_score):
	score=new_score
	$MainInterface.update_score(new_score)
	$Spawner.update_score(new_score)
func update_life(new_life):
	life=max(0,min(new_life,7))
	$MainInterface.update_life(life)

func new_game():
	update_score(0)
	update_life(5)
	$Cursor.start($StartCursor.position)
	$MainInterface.start()
	$Spawner.start()
	
	
func game_over():
	update_life(life-1)
	if !life :
		$Spawner.clear_screen()
		$Cursor.stop()
		$Spawner.stop()
		$MainInterface.stop()
		$GameOver.start(score)

func _on_cursor_shoot(collision:Array[Node2D]) -> void:
	for node in collision:
		if node.is_in_group("ball"):
			if node.stars_ball:
				update_life(life+1)
				update_score(score+$Spawner.clear_screen()*2)
				return 
			else:
				update_score(score+1)
				node.destroy()
				
		if node.is_in_group("bomb"):
			game_over()
			node.destroy()

	

func _on_game_over_home() -> void:
	$Menu.start()
