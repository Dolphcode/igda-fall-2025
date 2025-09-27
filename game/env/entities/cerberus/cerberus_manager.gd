extends Node
class_name CerberusManager


# Onready
@onready var window_man: WindowManager = get_parent().get_node("%WindowManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var r = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not r:
		var view: EnvView = window_man.env_views.pick_random()
		var cerberus: CerberusInstance = view.get_node("Cerberus")
		if not cerberus.instance_active:
			cerberus.activate_instance()
		r = true
