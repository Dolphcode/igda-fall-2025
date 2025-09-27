extends Node
class_name LaLloronaManager


# Onready
@onready var window_man: WindowManager = get_parent().get_node("%WindowManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	window_man.env_views.pick_random().get_node("%LaLloronaEntity").activate_instance()
