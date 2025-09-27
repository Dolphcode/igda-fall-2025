extends Node2D
## The game manager is responsible for translating player offsets to the actual
## state of the game, by moving and scrolling the tile map and adjusting the player's
## position. The game manager also manages the camera and adjusts it's position based on game
## staet
class_name GameManager

# Config
@export_category("Minigame Config")
@export var camera_speed: float = 20

# Onready
@onready var player: Player = %Player
@onready var map: MapGenerator = %Map
@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.position = player.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Perform X displacement
	var map_center_disp = roundi((map.max_col - map.min_col) * 0.5)
	player.tile_offset.x = player.tile_offset.x
	player.position.x = (player.tile_offset.x + map_center_disp) * map.tile_size
	
	# Perform Y displacement
	if player.tile_offset.y != 0:
		map.position.y -= player.tile_offset.y * map.tile_size
		if player.tile_offset.y < 0:
			map.raise_tiles()
		else:
			map.lower_tiles()
		camera.position.y = minf(player.position.y, camera.position.y - player.tile_offset.y * map.tile_size)
		player.tile_offset.y -= sign(player.tile_offset.y)
		
	# Move camera
	camera.position.y -= delta * camera_speed
