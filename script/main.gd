extends Node2D

@export var ball_scene :PackedScene
@export var bomb_scene :PackedScene
var screen_size:Vector2
var score:int 
var life :int
const DELAY_EXTRA_BALL_GROUP_FACTOR=0.7
const DELAY_EXTRA_BOMB_GROUP_FACTOR=0.1
const difficultys={
	"easy":{
		"ScoreRange":Vector2(0,30),
		
		"SpawnBallDelay": Vector2(1,0.8),
		"GravityBall": Vector2(-0.2,-0.25),
		"SizeBall":Vector2(1,0.8),
		"GroupBall":Vector2(1,1),
		
		"SpawnBombDelay": Vector2(4,3.5),
		"BombTimeMove":Vector2(5,4),
		"SizeBomb":Vector2(1,1.2),
		"GroupBomb":Vector2(1,1)
		
	},
	"medium":{
		"ScoreRange":Vector2(30,100),
		
		"SpawnBallDelay": Vector2(0.8,0.7),
		"GravityBall": Vector2(-0.25,-0.35),
		"SizeBall":Vector2(0.8,0.6),
		"GroupBall":Vector2(1,2),
		
		"SpawnBombDelay": Vector2(3.5,3),
		"BombTimeMove":Vector2(4,3),
		"SizeBomb":Vector2(1.1,1.4),
		"GroupBomb":Vector2(1,2)
	},
	"hard":{
		"ScoreRange":Vector2(100,200),
		
		"SpawnBallDelay": Vector2(0.85,0.65),
		"GravityBall": Vector2(-0.3,-0.35),
		"SizeBall":Vector2(0.6,0.4),
		"GroupBall":Vector2(2,3),
		
		"SpawnBombDelay": Vector2(3,2.5),
		"BombTimeMove":Vector2(3,2.5),
		"SizeBomb":Vector2(1.4,1.6),
		"GroupBomb":Vector2(2,3)
	}
}
var current_difficulty:Dictionary

func get_value_based_score(element:String,difficulty:Dictionary ,score:int):
	var score_amplitude=difficulty["ScoreRange"]
	var clamped_score=min(max(score,score_amplitude.x),score_amplitude.y)
	var normalized_score=(clamped_score-score_amplitude.x)/(score_amplitude.y-score_amplitude.x)
	var value:Vector2=difficulty[element]
	return value.x+(value.y-value.x)* normalized_score
func SetSpawnBombDelay(score:int):
	$SpawnBombDelay.wait_time=get_value_based_score("SpawnBombDelay",current_difficulty,score)
func SetSpawnBallDelay(score:int):
	$SpawnBallDelay.wait_time=get_value_based_score("SpawnBallDelay",current_difficulty,score)
func update_score(value):
	score+=value
	$MainInterface.update_score(score)
	if score>=0 and score<30 :
		current_difficulty=difficultys["easy"]
	elif score>=30 and score<100:
		current_difficulty=difficultys["medium"]
	elif score>=100:
		current_difficulty=difficultys["hard"]
func _ready() -> void:
	screen_size=get_viewport_rect().size
	new_game()

func clear_screen():
		update_score(get_tree().get_node_count_in_group("ball"))
		get_tree().call_group("ball","destroy")
		get_tree().call_group("bomb","destroy")	
func new_game():
	current_difficulty=difficultys["easy"]
	score=0
	life=5
	SetSpawnBallDelay(0)
	SetSpawnBombDelay(0)
	$Cursor.start($StartCursor.position)
	$MainInterface.start()
	$SpawnBallDelay.start()
	$SpawnBombDelay.start()
	
	
func game_over():
	life-=1
	$MainInterface.update_life(life)
	if life==0 :
		$SpawnBallDelay.stop()
		$SpawnBombDelay.stop()
		$Cursor.stop()
		clear_screen()
		$MainInterface.game_over()

func _on_cursor_shoot(collision:Array[Node2D]) -> void:
	for node in collision:
		if node.is_in_group("ball"):
			update_score(1)
			node.quit_screen.disconnect(game_over)
			if node.stars_ball:
				life=min(life+1,5)
				$MainInterface.update_life(life)
				clear_screen()
			else:
				node.destroy()
		if node.is_in_group("bomb"):
			node.destroy()
			game_over()

func _on_spawn_ball_delay_timeout() -> void:
	var ball: Ball 
	var size=get_value_based_score("SizeBall",current_difficulty,score)
	var gravity_scale=get_value_based_score("GravityBall",current_difficulty,score)
	var GroupBallAmplitude=current_difficulty["GroupBall"]
	var GroupBallNumber=randi_range(GroupBallAmplitude.x,GroupBallAmplitude.y)
	for i in range(GroupBallNumber):
		ball=ball_scene.instantiate()
		ball.quit_screen.connect(game_over)
		$PlaceBall.add_child(ball)
		var pos=Vector2(randi_range(100,screen_size.x-100),screen_size.y)
		ball.start(pos,Vector2(size,size),gravity_scale,randi_range(0,50)==0) 
	SetSpawnBallDelay(score)
	$SpawnBallDelay.wait_time*=1+(GroupBallNumber-1)*DELAY_EXTRA_BALL_GROUP_FACTOR
	$SpawnBallDelay.start()
	
	
func _on_spawn_bomb_delay_timeout() -> void:
	var bomb:Bomb
	var size=get_value_based_score("SizeBomb",current_difficulty,score)
	var move_time=get_value_based_score("BombTimeMove",current_difficulty,score)
	var GroupBombAmplitude=current_difficulty["GroupBomb"]
	var GroupBombNumber=randi_range(GroupBombAmplitude.x,GroupBombAmplitude.y)
	for i in range(GroupBombNumber):
		bomb=bomb_scene.instantiate()
		$PlaceBomb.add_child(bomb)
		var peak=Vector2(randi_range(100,screen_size.x-100),randi_range(200,screen_size.y-200))
		var pos=Vector2(peak.x+randf_range(-250,250),screen_size.y)
		bomb.start(pos,peak,Vector2(size,size),move_time)
	SetSpawnBombDelay(score)
	$SpawnBombDelay.wait_time*=1+(GroupBombNumber-1)*DELAY_EXTRA_BOMB_GROUP_FACTOR
	$SpawnBombDelay.start()
	
func _on_main_interface_reset() -> void:
	new_game()
