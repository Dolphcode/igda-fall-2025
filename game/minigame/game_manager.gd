extends Node2D
## The game manager is responsible for translating player offsets to the actual
## state of the game, by moving and scrolling the tile map and adjusting the player's
## position. The game manager also manages the camera and adjusts it's position based on game
## staet
class_name GameManager


@onready var player: Player = %Player
@onready var map: MapGenerator = %Map
@onready var camera: Camera2D = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	camera.position = player.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.tile_offset.x != 0:
		player.position.x += player.tile_offset.x * map.tile_size
		player.tile_offset.x -= sign(player.tile_offset.x)
	if player.tile_offset.y != 0:
		map.position.y -= player.tile_offset.y * map.tile_size
		if player.tile_offset.y < 0:
			map.raise_tiles()
			camera.position.y = minf(player.position.y, camera.position.y - player.tile_offset.y * map.tile_size)
		else:
			map.lower_tiles()
		player.tile_offset.y -= sign(player.tile_offset.y)
		
		
	
	camera.position.y -= delta * 20
