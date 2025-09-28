extends Node
class_name CerberusManager

@export_category("Difficulty Config")
@export var spawn_time: float = 5.0

var spawn_counter: float = 0

# Onready
@onready var window_man: WindowManager = get_parent().get_node("%WindowManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var r = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_counter += delta
	if spawn_counter >= spawn_time:
		spawn_counter = 0
		
		var valid_views: Array[EnvView] = []
		for view in window_man.env_views:
			if view.frankenstein_occupied:
				continue
			valid_views.append(view)
		
		if len(valid_views) == 0:
			return
			
		var view: EnvView = valid_views.pick_random()
		var cerberus: CerberusInstance = view.get_node("Cerberus")
		if not cerberus.instance_active:
			cerberus.activate_instance()
