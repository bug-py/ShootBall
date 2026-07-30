extends Node

const difficultys={
	"easy":{
		"ScoreRange":Vector2(0,50),
		
		"SpawnBallDelay": Vector2(1,0.9),
		"GravityBall": Vector2(-0.15,-0.2),
		"SizeBall":Vector2(1,0.8),
		"GroupBall":Vector2(1,1),
		
		"SpawnBombDelay": Vector2(4,3.5),
		"BombTimeMove":Vector2(5,4),
		"SizeBomb":Vector2(1,1.2),
		"GroupBomb":Vector2(1,1)
		
	},
	"medium":{
		"ScoreRange":Vector2(50,100),
		
		"SpawnBallDelay": Vector2(0.9,0.8),
		"GravityBall": Vector2(-0.2,-0.25),
		"SizeBall":Vector2(0.8,0.6),
		"GroupBall":Vector2(1,2),
		
		"SpawnBombDelay": Vector2(3.5,3),
		"BombTimeMove":Vector2(4,3),
		"SizeBomb":Vector2(1.2,1.4),
		"GroupBomb":Vector2(1,2)
	},
	"hard":{
		"ScoreRange":Vector2(100,150),
		
		"SpawnBallDelay": Vector2(0.9,0.8),
		"GravityBall": Vector2(-0.25,-0.28),
		"SizeBall":Vector2(0.6,0.4),
		"GroupBall":Vector2(1,3),
		
		"SpawnBombDelay": Vector2(3,2.5),
		"BombTimeMove":Vector2(3,2.5),
		"SizeBomb":Vector2(1.4,1.6),
		"GroupBomb":Vector2(2,3)
	},
	"insane":{
		"ScoreRange":Vector2(150,250),
		
		"SpawnBallDelay": Vector2(0.8,0.7),
		"GravityBall": Vector2(-0.28,-0.38),
		"SizeBall":Vector2(0.4,0.35),
		"GroupBall":Vector2(1,4),
		
		"SpawnBombDelay": Vector2(3,2.5),
		"BombTimeMove":Vector2(3,2.5),
		"SizeBomb":Vector2(1.6,1.7),
		"GroupBomb":Vector2(2,3)
	}
}
var current_difficulty:Dictionary
var score:int 
func update_score(new_value):
	score=new_value
	if score>=0 and score<50 :
		current_difficulty=difficultys["easy"]
	elif score>=50 and score<100:
		current_difficulty=difficultys["medium"]
	elif score>=100 and score<150:
		current_difficulty=difficultys["hard"]
	elif score>=150:
		current_difficulty=difficultys["insane"]
func reset():
	score=0
	current_difficulty=difficultys["easy"]

func get_value_random(element):
	var interval:Vector2=current_difficulty[element]
	return randi_range(interval.x,interval.y)
	
func get_value_based_score(element:String):
	var score_amplitude=current_difficulty["ScoreRange"]
	var clamped_score=min(max(score,score_amplitude.x),score_amplitude.y)
	var normalized_score=(clamped_score-score_amplitude.x)/(score_amplitude.y-score_amplitude.x)
	var value:Vector2=current_difficulty[element]
	return value.x+(value.y-value.x)* normalized_score

	
