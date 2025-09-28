extends Node2D
## The game manager manages the game state. It is responsible for updating the state 
## of the minigame based on player input and minigame entity state changes. The minigame
## is also connected to the background environment
class_name GameManager

# Config
@export_category("Minigame Config")
@export var camera_speed: float = 20

@export_category("Environment Config")
@export var jumpscares: Array[Texture2D]

@export_category("General Config")
@export var max_move_steps: int = 2


# Onready
@onready var player: Player = %Player
@onready var map: MapGenerator = %Map
@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.position = player.position
	
	%WindowManager.create_env_view()
	%WindowManager.create_env_view()
	%WindowManager.create_env_view()
	%WindowManager.create_env_view()
	%WindowManager.create_env_view()
	%WindowManager.create_env_view()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Perform X displacement
	var map_center_disp = roundi((map.max_col - map.min_col) * 0.5)
	player.tile_offset.x = player.tile_offset.x
	player.position.x = (player.tile_offset.x + map_center_disp) * map.tile_size
	if player.on_log:
		player.position.x += player.curr_log.position.x - player.curr_log.accum_position.x
	
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


## Call this function to trigger the lose game
func lose_game():
	%Environment.process_mode = PROCESS_MODE_DISABLED
	%Map.process_mode = PROCESS_MODE_DISABLED
	%WindowManager.process_mode = PROCESS_MODE_DISABLED
	
	for env in %WindowManager.env_views:
		env.get_node("Jumpscare").visible = true
		env.get_node("Jumpscare/TextureRect").texture = jumpscares.pick_random()
