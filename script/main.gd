extends Node2D

@export var ball_scene :PackedScene
@export var bomb_scene :PackedScene
var screen_size:Vector2
var score:int 
var life :int
func _ready() -> void:
	screen_size=get_viewport_rect().size
	new_game()
	
func new_game():
	$Cursor.start($StartCursor.position)
	$MainInterface.start()
	$SpawnBallDelay.start()
	$SpawnBombDelay.start()
	score=0
	life=5
	
func game_over():
	life-=1
	if life==0 :
		$SpawnBallDelay.stop()
		$SpawnBombDelay.stop()
		$Cursor.stop()
		get_tree().call_group("ball","destroy")
		get_tree().call_group("bomb","destroy")
		$MainInterface.game_over()
		
func _on_cursor_shoot(collision:Array[Node2D]) -> void:
	for node in collision:
		print(node)
		if node.is_in_group("ball"):
			score+=1
			$MainInterface.update_score(score)
			node.quit_screen.disconnect(game_over)
			node.destroy()
		if node.is_in_group("bomb"):
			node.destroy()
			game_over()

func _on_spawn_ball_delay_timeout() -> void:
	var ball: Ball =ball_scene.instantiate()
	ball.quit_screen.connect(game_over)
	$PlaceBall.add_child(ball)
	var pos=Vector2(randi_range(100,screen_size.x-100),screen_size.y)
	ball.start(pos,Vector2(1,1),-0.4) 
	
	
func _on_spawn_bomb_delay_timeout() -> void:
	var bomb:Bomb=bomb_scene.instantiate()
	$PlaceBomb.add_child(bomb)
	var pos=Vector2(randi_range(100,screen_size.x-100),screen_size.y)
	var peak=Vector2(randi_range(100,screen_size.x-100),randi_range(200,screen_size.y-200))
	bomb.start(pos,peak,Vector2(1,1),3)
	
func _on_main_interface_reset() -> void:
	new_game()
