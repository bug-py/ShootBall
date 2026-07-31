extends Node
@export_category("Init Animation")
@export_group("Scale")
@export var enable_scale:bool
@export var begin_scale:float
@export var end_scale :float
@export var time_scale:float
@export_group("Opacity")
@export var enable_opacity:bool
@export var time_opacity :float
var begin_opacity=Color(255,255,255,0)
var end_opacity=Color(255,255,255,1)
var current:Control
func _ready():
	var parent=get_parent()
	if not is_instance_of(parent,Control):
		return 
	current=parent
func start():
	var tween=create_tween()
	tween.set_parallel(true)
	if(enable_scale):
		current.scale=Vector2(begin_scale,begin_scale)
		tween.tween_property(current,"scale",Vector2(end_scale,end_scale),time_scale)
	if(enable_opacity):
		current.modulate=begin_opacity
		tween.tween_property(current,"modulate",end_opacity,time_opacity)
	 
	
