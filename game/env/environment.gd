extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set up environment to match display screen size
	var main_screen: int = DisplayServer.get_primary_screen()
	var screen_size: Vector2i = DisplayServer.screen_get_size(main_screen)
	self.size = screen_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
