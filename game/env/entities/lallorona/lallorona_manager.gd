extends Entity
class_name LaLloronaManager


# Onready
@onready var window_man: WindowManager = get_parent().get_node("%WindowManager")

var timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ent_process(delta):
	timer += delta
	if timer >= 10:
		timer = 0
		window_man.env_views.pick_random().get_node("%LaLloronaEntity").activate_instance()
