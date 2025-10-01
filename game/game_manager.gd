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
@export var restart_game_scene: String = "res://game/minigame/minigame.tscn"

@export_category("Lose Screen Config")
@export var lose_screen: CanvasLayer
@export var error_label: Label

@export_category("Progression Config")
@export var progression_enabled: bool = true
@export var init_num_windows: int = 6
@export var min_time_per_progression: float = 10
@export var max_time_per_progression: float = 20
@export var progression_order: Array[String]

var lose = false
var next_prog_timeout: float = 0
var prog_timer: float = 0
var prog_index: int = 0

# Onready
@onready var player: Player = %Player
@onready var map: MapGenerator = %Map
@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if not OS.is_debug_build():
		get_window().content_scale_size = Vector2i(864, 486)
		get_window().size = Vector2i(864, 486) 
		get_window().content_scale_factor = 0.75
		
	camera.position = player.position
	
	for i in range(init_num_windows):
		%WindowManager.create_env_view()
	
	next_prog_timeout = randf_range(min_time_per_progression, max_time_per_progression)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check progression
	if progression_enabled and prog_index < len(progression_order):
		
		prog_timer += delta
		if prog_timer >= next_prog_timeout:
			next_prog_timeout = randf_range(min_time_per_progression, max_time_per_progression)
			prog_timer = 0
			
			# Apply the prog index
			if progression_order[prog_index] == "Window":
				%WindowManager.create_env_view()
			else:
				%Environment.get_node(progression_order[prog_index]).enable_entity()
			
			prog_index += 1

	
	# Perform X displacement
	var map_center_disp = roundi((map.max_col - map.min_col) * 0.5)
	player.tile_offset.x = player.tile_offset.x
	player.position.x = (player.tile_offset.x + map_center_disp) * map.tile_size
	if player.on_log:
		if player.curr_log == null or player.curr_log.is_queued_for_deletion():
			player.curr_log = null
			player.on_log = false
		else:
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
	if not lose: 
		camera.position.y -= delta * camera_speed


## Call this function to trigger the lose game
func lose_game(reason: String):
	lose_screen.visible = true
	error_label.text = "ERROR CODE: " + reason
	lose = true	
	
	%Environment.process_mode = PROCESS_MODE_DISABLED
	%Map.process_mode = PROCESS_MODE_DISABLED
	%WindowManager.process_mode = PROCESS_MODE_DISABLED
	%Player.process_mode = PROCESS_MODE_DISABLED
	
	for env in %WindowManager.env_views:
		env.get_node("Jumpscare").visible = true
		env.get_node("Jumpscare/TextureRect").texture = jumpscares.pick_random()


func restart_game():
	get_tree().change_scene_to_file(restart_game_scene)

func return_to_main():
	get_tree().change_scene_to_file("res://menu/main_menu/main_menu.tscn")
