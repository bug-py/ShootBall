extends CanvasLayer
@export var cloud_scene:PackedScene
@export var cloud_count:int=100

func _ready() -> void:
	for i in cloud_count:
		create_cloud()
		await get_tree().create_timer(0.5).timeout

func create_cloud():
	var cloud:Cloud=cloud_scene.instantiate()
	cloud.exit_screen.connect(create_cloud)
	$PlaceCloud.add_child(cloud)
