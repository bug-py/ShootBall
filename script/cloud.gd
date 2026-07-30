extends AnimatedSprite2D
class_name  Cloud
signal exit_screen
const scale_interval=Vector2(5,9)
const speed_interval=Vector2(100,175)
var current_speed:int;

func apply(value,weigth):
	return value.x+(value.y-value.x)*weigth

func _ready()->void:
	var screen_size=get_viewport_rect().size
	var normalized_random=randf()
	current_speed=apply(speed_interval,normalized_random)
	var size=apply(scale_interval,normalized_random)
	scale=Vector2(size,size)
	position=Vector2(0,randf_range(0,screen_size.y))
	flip_h=[true,false].pick_random()
	frame=randi_range(0,1)
	


func _process(delta: float) -> void:
	position+=Vector2.RIGHT*current_speed*delta



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	await $VisibleOnScreenNotifier2D.screen_exited
	queue_free()
	exit_screen.emit()
