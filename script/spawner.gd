extends Node2D

var screen_size:Vector2
@export var ball_scene:PackedScene
@export var bomb_scene:PackedScene
const DELAY_EXTRA_BALL_GROUP_FACTOR=0.55
const DELAY_EXTRA_BOMB_GROUP_FACTOR=0.2
signal ball_leave
func _ready():
	screen_size=get_viewport_rect().size
func start(init_score:int):
	$DifficultyManager.update_score(init_score)
	$SpawnBallDelay.wait_time=$DifficultyManager.get_value_based_score("SpawnBallDelay")
	print($DifficultyManager.get_value_based_score("SpawnBallDelay"))
	$SpawnBombDelay.wait_time=$DifficultyManager.get_value_based_score("SpawnBombDelay")
	$SpawnBallDelay.start()
	$SpawnBombDelay.start()
func stop():
	$SpawnBallDelay.stop()
	$SpawnBombDelay.stop()
func clear_screen():
	var bonus=get_tree().get_node_count_in_group("ball")
	get_tree().call_group("ball","destroy")
	get_tree().call_group("bomb","destroy")
	return bonus
func update_timer_delay(timer:Timer,count_element:int,delay_extra_factor:float):
	var time_one_element=$DifficultyManager.get_value_based_score(timer.name)
	var factor=1+(count_element-1)*delay_extra_factor
	timer.wait_time=time_one_element*factor
	
func update_score(score):
	$DifficultyManager.update_score(score)

func _on_spawn_bomb_delay_timeout() -> void:
	var bomb_count=$DifficultyManager.get_value_random("GroupBomb")
	var size=$DifficultyManager.get_value_based_score("SizeBomb")
	var time_move=$DifficultyManager.get_value_based_score("BombTimeMove")
	for i in range(bomb_count):
		var bomb:Bomb=bomb_scene.instantiate()
		$PlaceBomb.add_child(bomb)
		var peak=Vector2(randf_range(100,screen_size.x-100),randf_range(200,screen_size.y-200))
		var pos=Vector2(peak.x+randf_range(-250,250),screen_size.y)
		bomb.start(pos,peak,Vector2(size,size),time_move)
	update_timer_delay($SpawnBombDelay,bomb_count,DELAY_EXTRA_BOMB_GROUP_FACTOR)
	$SpawnBombDelay.start()


func _on_spawn_ball_delay_timeout() -> void:
	var ball_count=$DifficultyManager.get_value_random("GroupBall")
	var size=$DifficultyManager.get_value_based_score("SizeBall")
	var gravity_scale=$DifficultyManager.get_value_based_score("GravityBall")
	for i in range(ball_count):
		var ball:Ball=ball_scene.instantiate()
		ball.quit_screen.connect(ball_leave.emit)
		$PlaceBall.add_child(ball)
		var pos=Vector2(randf_range(100,screen_size.x-100),screen_size.y)
		ball.start(pos,Vector2(size,size),gravity_scale,randi_range(0,25)==0)
	update_timer_delay($SpawnBallDelay,ball_count,DELAY_EXTRA_BALL_GROUP_FACTOR)
	$SpawnBallDelay.start()

	
