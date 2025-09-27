extends Node
## Manages windows and exposes information about windows to other objects
class_name WindowManager

@export var env_view_scene: PackedScene

## An array of active environment views
var env_views: Array[EnvView]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func create_env_view():
	var view: EnvView = env_view_scene.instantiate()
	call_deferred("add_child", view)
	view.environment = %Environment
	env_views.append(view)
	
