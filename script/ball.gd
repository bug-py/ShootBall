extends RigidBody2D
class_name Ball
signal quit_screen
var stars_ball:bool;
func _ready() -> void:
	hide()
	var color: String=["blue","green","red"].pick_random()
	$AnimatedSprite2D.animation=color
	$DestroyParticles.process_material.color=color
	
	
func start(pos:Vector2,size:Vector2,gravity:float,special:bool):
	$CollisionShape2D.disabled=false
	position=pos
	scale=size
	gravity_scale=gravity
	stars_ball=special
	if(stars_ball):
		gravity_scale=-0.9
		$StartParticles.restart(false)
	$AnimatedSprite2D.play()
	show()
func destroy():
	gravity_scale=0
	linear_velocity=Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled",true)
	$AnimatedSprite2D.visible=false
	$DestroyParticles.restart(false)
	await $DestroyParticles.finished
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if(not stars_ball):
		quit_screen.emit()
	queue_free()
