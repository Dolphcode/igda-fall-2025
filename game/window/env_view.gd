extends Window
class_name EnvView

@export_category("Window Property Config")
@export var screen_fraction: float = 0.25

@export_category("Capture Config")
@export var environment: SubViewport

# Onready vars
@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get screen parameters
	var main_screen: int = DisplayServer.get_primary_screen()
	var screen_size: Vector2i = DisplayServer.screen_get_size(main_screen)
	
	# Set window params
	var window_size: int = roundi(min(screen_size.x, screen_size.y) * screen_fraction)
	self.size = Vector2i(window_size, window_size)
	self.unresizable = true
	self.minimize_disabled = true
	self.maximize_disabled = true
	self.always_on_top = true
	self.world_2d = environment.world_2d


var delta: Vector2i = Vector2i.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Sync camera position to screen position
	camera.position = position + Vector2i(0.5 * self.size)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_POSITION_CHANGED:
		#camera.queue_redraw()
		pass
