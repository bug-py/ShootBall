extends RigidBody2D
class_name Ball
signal quit_screen

func _ready() -> void:
	hide()
	var color: String=["blue","green","red"].pick_random()
	$AnimatedSprite2D.animation=color
	$GPUParticles2D.process_material.color=color
	
	
func start(pos:Vector2,size:Vector2,gravity:float):
	$CollisionShape2D.disabled=false
	position=pos
	size=size
	gravity_scale=gravity
	$AnimatedSprite2D.play()
	show()
func destroy():
	gravity_scale=0
	linear_velocity=Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled",true)
	$AnimatedSprite2D.visible=false
	$GPUParticles2D.restart(false)
	await $GPUParticles2D.finished
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	quit_screen.emit()
	queue_free()
