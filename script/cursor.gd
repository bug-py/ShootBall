extends Area2D

@export var speed : float =3400
@export var angular_speed_move : float=360
@export var angular_speed_still: float=125
@export var min_len_shoot : float =45
var collision_node: Array[Node2D]=[]
var screen_size : Vector2
signal shoot


	
func start(pos):
	collision_node=[]
	$CollisionShape2D.set_deferred("disabled",false)		
	$AnimatedSprite2D.animation="move"
	$AnimatedSprite2D.play()
	position=pos
	set_process(true)
	show()
	
func stop():
	$CollisionShape2D.set_deferred("disabled",true)		
	$AnimatedSprite2D.stop()
	set_process(false)
	hide()

func _ready() -> void:
	screen_size=get_viewport_rect().size
	stop()


	
func make_shoot():
	if Input.is_action_just_pressed("shoot"): 
		if(collision_node):
			shoot.emit(collision_node)
		var tween=create_tween()
		tween.tween_property(self,"scale",Vector2(0.8,0.8),0.1)
		tween.tween_property(self,"scale",Vector2(1.0,1.0),0.1)
		
	
		
func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var move = mouse_pos-position
	var len=move.length()
	if len :
		rotation_degrees+=angular_speed_move*delta
		position+=move.normalized() * min(speed*delta,len)
		position=position.clamp(Vector2.ZERO,screen_size)
	else :
		rotation_degrees+=angular_speed_still*delta
		
	if len<min_len_shoot :
		if collision_node :
			$AnimatedSprite2D.animation="trigger"
		else :
			$AnimatedSprite2D.animation="ready"
		make_shoot()
	else :
		$AnimatedSprite2D.animation="move"


func _on_node_entered(body: Node2D):
	collision_node.append(body)
	
func _on_node_exited(body: Node2D) -> void:
	collision_node.erase(body)
