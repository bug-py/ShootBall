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
	$SpawnDelay.start()
	score=0
	life=3

func _on_cursor_shoot(collision:Array[Node2D]) -> void:

	for node in collision:
		print(node)
		if node.is_in_group("ball"):
			score+=1
			$MainInterface.update_score(score)
			node.quit_screen.disconnect(game_over)
			node.destroy()
		if node.is_in_group("bomb"):
			node.queue_free()
			game_over()
			
func _on_spawn_delay_timeout() -> void:
	var ball: Ball =ball_scene.instantiate()
	ball.quit_screen.connect(game_over)
	$PlaceBall.add_child(ball)
	var pos=Vector2(randi_range(100,screen_size.x-100),screen_size.y)
	ball.start(pos,Vector2(1,1),-0.4) 
	ball =ball_scene.instantiate()
	ball.quit_screen.connect(game_over)
	$PlaceBall.add_child(ball)
	pos=Vector2(randi_range(100,screen_size.x-100),screen_size.y)
	ball.start(pos,Vector2(1,1),-0.4) 
	var bomb: Bomb =bomb_scene.instantiate()
	$PlaceBomb.add_child(bomb)
	pos=Vector2(randi_range(100,screen_size.x-100),screen_size.y)
	var peak=Vector2(randi_range(100,screen_size.x-100),randi_range(200,screen_size.y-200))
	bomb.start(pos,$Cursor.position,Vector2(1,1),4)
	bomb=bomb_scene.instantiate()
	$PlaceBomb.add_child(bomb)
	pos=Vector2(randi_range(100,screen_size.x-100),screen_size.y)
	bomb.start(pos,peak,Vector2(1,1),4)
	

func game_over():
	life-=1
	if life==0 :
	
		$SpawnDelay.stop()
		$Cursor.stop()
		get_tree().call_group("ball","destroy")
		get_tree().call_group("bomb","queue_free")
		$MainInterface.game_over()
	
func _on_main_interface_reset() -> void:
	new_game()
