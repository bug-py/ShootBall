extends Node
@export_category("Hover")
@export_group("Scale")
@export var min_scale:float
@export var max_scale:float
@export var time_scale:float
var tween:Tween
var current:Control;
func _ready():
	var parent=get_parent()
	if not is_instance_of(parent,Control):
		return 
	current=parent
	
func start():
	current.scale=Vector2(min_scale,min_scale)
	current.mouse_entered.connect(make_anim)
	current.mouse_exited.connect(undo_anim)
func stop():
	current.mouse_entered.disconnect(make_anim)
	current.mouse_exited.disconnect(undo_anim)
func reset_tween():
	if tween:
		tween.kill()
	tween=create_tween()
func make_anim():
	reset_tween()
	tween.tween_property(current,"scale",Vector2(max_scale,max_scale),time_scale)
func undo_anim():
	reset_tween()
	tween.tween_property(current,"scale",Vector2(min_scale,min_scale),time_scale)
