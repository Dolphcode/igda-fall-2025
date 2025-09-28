extends Window
## Represents a view of the background environment via a window
class_name EnvView

@export_category("Window Property Config")
@export var screen_fraction: float = 0.25

@export_category("Capture Config")
@export var environment: SubViewport

var frankenstein_occupied: bool = false

# Onready vars
@onready var camera: Camera2D = $Camera2D

var last_pos: Vector2
var last_vel: Vector2 = Vector2.ZERO
var curr_vel: Vector2 = Vector2.ZERO
var accel: float = 0
var accel_accum: float = 0

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
	
	last_pos = camera.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	last_pos = camera.position
	last_vel = curr_vel
	# Sync camera position to screen position
	camera.position = position + Vector2i(0.5 * self.size)
	curr_vel = (camera.position - last_pos) / delta
	accel = (curr_vel - last_vel / delta).length()
	accel_accum = (accel_accum * 0.25) + (accel * 0.75)
	if accel_accum > 5e5:
		if %LaLloronaEntity.instance_active:
			%LaLloronaEntity.shake_count += 1


func la_llorona_active():
	return %LaLloronaEntity.instance_active


func cerberus_active():
	return %Cerberus.instance_active
