extends Area2D

@export var speed : float =2500
@export var angular_speed_move : float=180
@export var angular_speed_still: float=90
@export var min_len_shoot : float =15
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
	$ShootDelay.stop()
	set_process(false)
	hide()

func _ready() -> void:
	screen_size=get_viewport_rect().size
	stop()	
	
func make_shoot():
	if Input.is_action_just_pressed("shoot"): 
		if(collision_node):
			shoot.emit(collision_node)
		$ShootDelay.start()
		set_process(false)
	
		
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


func _on_body_entered(body: Node2D):
	collision_node.append(body)
	
func _on_body_exited(body: Node2D) -> void:
	collision_node.erase(body)


func _on_shoot_delay_timeout() -> void:
	set_process(true)
