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

## State variable to determine if the player is on a log
var on_log: bool = false
## The current log we are on
var curr_log: Log

@onready var game_manager: GameManager = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	var map: MapGenerator = %Map
	tile_position = Vector2i(int(0.5 * (map.max_col - map.min_col)) - 1, map.min_row - 1 - roundi(0.5 * map.tilemap_height))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# We can only
	var next_position: Vector2i = tile_position
	var next_offset: Vector2i = tile_offset
	if Input.is_action_just_pressed("up"):
		next_offset.y -= 1
		next_position.y -= 1
	if Input.is_action_just_pressed("down"):
		next_offset.y += 1
		next_position.y += 1
	if Input.is_action_just_pressed("left"):
		next_offset.x -= 1
		next_position.x -= 1
		self.flip_h = false
	if Input.is_action_just_pressed("right"):
		next_offset.x += 1
		next_position.x += 1
		self.flip_h = true
	
	# Only perform collision checks if we are changing tiles
	if next_offset != tile_offset:
	
		if %Map.ground_layer.get_cell_atlas_coords(next_position).y == 2:
			# This for loop will identify if we are stepping onto a log, thus we set
			# on_log to false tempirarily and only set it back to true in this frame
			# if we do step onto a log
			for obj in %Map.get_children():
				# Skip non-log objects
				if not obj.is_in_group("log"):
					continue
				
				# Test if we are on this particular log
				var log_origin: Vector2i = %Map.to_tile_pos(obj.get_parent().to_global(obj.accum_position))
				if log_origin.y == next_position.y and (log_origin.x <= next_position.x and log_origin.x + obj.body_size > next_position.x):
					# Make sure player is on log
					on_log = true
					
					# Update actual offset and position
					tile_offset = next_offset
					tile_position = next_position
					
					# Check if different logs and update accordingly
					if curr_log != obj:
						if curr_log != null and not curr_log.is_queued_for_deletion():
							curr_log.on_log_move.disconnect(_on_log_move_time)
						
						curr_log = obj
						curr_log.on_log_move.connect(_on_log_move_time)
					break
		else:
			# Evaluate other possible states
			if %Map.obstacle_layer.get_cell_tile_data(next_position) == null:
				tile_offset = next_offset
				tile_position = next_position
				
				# If a move is successful
				# Attempt to disconnect log node since if we aren't stepping on a potential water tile
				# We cannot possibly be stepping onto a log
				on_log = false
				if curr_log != null and not curr_log.is_queued_for_deletion():
					curr_log.on_log_move.disconnect(_on_log_move_time)
					curr_log = null
				


func _on_log_move_time() -> void:
	tile_offset.x += curr_log.direction
	tile_position.x += curr_log.direction
