extends Node
## Manages windows and exposes information about windows to other objects
class_name WindowManager

@export var env_view_scene: PackedScene

## An array of active environment views
var env_views: Array[EnvView]


func create_env_view():
	var view: EnvView = env_view_scene.instantiate()
	var main_screen: int = DisplayServer.get_primary_screen()
	var screen_size: Vector2i = DisplayServer.screen_get_size(main_screen)
	view.position.x = randi_range(view.size.x, screen_size.x - view.size.x)
	view.position.y = randi_range(view.size.y, screen_size.y - view.size.y)
	
	call_deferred("add_child", view)
	view.environment = %Environment
	env_views.append(view)
	
