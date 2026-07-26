extends Node2D

@export var ball_scene :PackedScene

var screen_size:Vector2
var score:int 
var life :int
func _ready() -> void:
	screen_size=get_viewport_rect().size
	new_game()
	
func new_game():
	$Cursor.start($StartCursor.position)
	$MainInterface.start()
	$SpawnDelay.start()
	score=0
	life=3

func _on_cursor_shoot(collision:Array[Node2D]) -> void:
	for node in collision:
		if node.is_in_group("ball"):
			score+=1
			$MainInterface.update_score(score)
			node.quit_screen.disconnect(game_over)
			node.destroy()
			
func _on_spawn_delay_timeout() -> void:
	var ball: Ball =ball_scene.instantiate()
	ball.quit_screen.connect(game_over)
	$PlaceBall.add_child(ball)
	var pos=Vector2(randi_range(100,screen_size.x-100),screen_size.y)
	ball.start(pos,Vector2(1,1),-1) 

func game_over():
	life-=1
	if life==0 :
		$SpawnDelay.stop()
		$Cursor.stop()
		get_tree().call_group("ball","destroy")
		$MainInterface.game_over()
	
func _on_main_interface_reset() -> void:
	new_game()
