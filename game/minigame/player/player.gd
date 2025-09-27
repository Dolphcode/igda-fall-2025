extends Node2D
## The player controller is responsible for taking player input and indicating that
## the game manager needs to update the player's position (which is really either an
## update of the player position itself or the tilemap's vertical position / state.
## The player controller is also responsible for registering whether the player has collided
## with some hazard or not, and causing the game over.
class_name Player

# State Variables
## The tile offset is modified by input and indicates the player or tilemap needs to be shifted by the game manager
var tile_offset: Vector2i = Vector2i.ZERO
## Always be tracking the tile position
var tile_position: Vector2i

@onready var game_manager: GameManager = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	var map: MapGenerator = %Map
	tile_position = Vector2i(int(0.5 * (map.max_col - map.min_col)) - 1, map.min_row - 1 - roundi(0.5 * map.tilemap_height))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# We can only
	var next_position: Vector2i = tile_position
	var next_offset: Vector2i = tile_offset
	if Input.is_action_just_pressed("ui_up"):
		next_offset.y -= 1
		next_position.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		next_offset.y += 1
		next_position.y += 1
	if Input.is_action_just_pressed("ui_left"):
		next_offset.x -= 1
		next_position.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		next_offset.x += 1
		next_position.x += 1

	print(tile_position)

	if %Map.obstacle_layer.get_cell_tile_data(next_position) == null:
		tile_offset = next_offset
		tile_position = next_position
	
