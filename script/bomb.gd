extends Area2D
class_name Bomb

const ellipse_degrees=Vector2(0,180)
var angular_degrees_speed;
var coefficient :Vector2
var half_ellipse_center:Vector2
var current_time :float=0
var max_time:float;

func _ready():
	angular_degrees_speed=randf_range(80,150)
	set_process(false)
	hide()
func start(pos :Vector2,peak :Vector2,size:Vector2,time:float):
	position=pos
	size=size
	max_time=time
	coefficient=pos-peak
	half_ellipse_center=Vector2(peak.x,pos.y)
	set_process(true)
	print(half_ellipse_center)
	$AnimatedSprite2D.play()
	show()
func apply(value:Vector2,weight:float)->float:
	return value.x+(value.y-value.x)*weight
func acelerate(progress:float)->float:
	return progress**2
func decelerate(progress:float)->float:
	return 1-(1-progress)**3

func jump(progress:float):
	var weight;
	var relative_weight:float
	var relative_progress:float
	if progress<=0.35:
		relative_progress=progress*2
		relative_weight=decelerate(relative_progress)
		return relative_weight/2
	if progress>0.35 and progress<0.75:
		var animation_weight=Vector2(decelerate(0.35*2)/2, acelerate((0.75-0.5)*2)/2+0.5)
		return apply(animation_weight,(progress-0.35)/0.40)
	if progress>=0.75:
		relative_progress=(progress-0.5)*2
		relative_weight=acelerate(relative_progress)
		return relative_weight/2+0.5


		
	   
func _process(delta: float) -> void:
	var weight=jump(current_time/max_time)
	var radians=deg_to_rad(apply(ellipse_degrees,weight))
	var relative_ellipse_move=Vector2(cos(radians),-sin(radians))*coefficient
	position=half_ellipse_center+relative_ellipse_move
	position.x=int(position.x)
	position.y=int(position.y)
	rotation_degrees+=angular_degrees_speed*delta
	current_time+=delta
func destroy():
	set_process(false)
	$CollisionShape2D.set_deferred("disabled",true)
	$AnimatedSprite2D.visible=false
	$GPUParticles2D.restart()
	await $GPUParticles2D.finished
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
