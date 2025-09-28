extends Node2D
## Responsible for generating and cleaning tiles upon request
class_name MapGenerator

# Enums
enum ChunkType {
	GRASS,
	ROAD,
	WATER
}

# Config
## NOTE: I could've auto configured this in _ready but for simplicity sake we can just copy that data here
@export_category("Tilemap Size Config")
## The total height the tilemap is allowed to be at any given point in time
@export var tilemap_height: int = 40
## The index of the bottom row of the tilemap
@export var min_row: int = 40
## The index of the leftmost column of the tilemap
@export var min_col: int = -1
## The index of the rightmost column of the tilemap
@export var max_col: int = 32

@export_category("Grass Area Config")
## The random rate at which trees are spawned when a grass chunk is generated
@export var tree_rate: float = 0.4
## The minimum of rows for a randomly generated chunk of grass terrain
@export var min_chunk_height_grass: int = 2
## The maximum number of rows for a randomly generated chunk of grass terrain
@export var max_chunk_height_grass: int = 7

@export_category("Road Config")
## The spawner object responsible for spawning cars on the road
@export var car_spawner: PackedScene
## half of the minimum number of rows for road
@export var min_num_roads: int = 1
## half the maximum number of rows for road
@export var max_num_roads: int = 2

@export_category("Water Config")
## The spawner object responsible for spawning logs on the road
@export var log_spawner: PackedScene
## The minimum of rows for a randomly generated chunk of water terrain
@export var min_chunk_height_water: int = 2
## The maximum of rows for a randomly generated chunk of water terrain
@export var max_chunk_height_water: int = 4

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var obstacle_layer: TileMapLayer = $ObstacleLayer
@onready var tile_size: int = ground_layer.tile_set.tile_size.x

# State
var accum: int = 0
var next_chunk: int = 0
var next_chunk_type: int = 0
var last_chunk: int = -1

## The lower bound where spawners should be destroyed
var spawner_lower_bound: float

# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomize the next chunk
	randomize_chunk()
	
	# Compute the lower bound where spawners should be killed
	var pos: Vector2 = obstacle_layer.map_to_local(Vector2i(0, min_row))
	pos = obstacle_layer.to_global(pos)
	spawner_lower_bound = pos.y
	
	pass # Replace with function body.


## Generates a random chunk of ground
func randomize_chunk():
	if last_chunk == -1:
		next_chunk_type = randi_range(0, 2)
		last_chunk = next_chunk_type
	else:
		next_chunk_type = randi_range(0, 1)
		if last_chunk == 0:
			next_chunk_type += 1
		elif last_chunk == 1 and next_chunk_type == 1:
			next_chunk_type = 2
		last_chunk = next_chunk_type
		
	if next_chunk_type == 0:
		next_chunk = randi_range(min_chunk_height_grass, max_chunk_height_grass)
	elif next_chunk_type == 1:
		next_chunk = randi_range(min_num_roads, max_num_roads) * 2
	elif next_chunk_type == 2:
		next_chunk = randi_range(min_chunk_height_water, max_chunk_height_water)
	
	
	


## Generates the next row based on the type of tile the row is
## TODO: Copy row to bottom area so that we can teleport the map up past a certain
##		 point to prevent overflow. Not super necessary though
## The row number relative is used specifically for ROAD.
func gen_row(cell_row: int, chunk_type: int, row_num_relative: int) -> void:
	# Implement obstacles if needed
	if chunk_type == ChunkType.GRASS:
		for i in range(min_col, max_col + 1):
			ground_layer.set_cell(Vector2i(i, cell_row), 0, Vector2i(randi_range(0, 3), chunk_type))
		
		obstacle_layer.set_cell(Vector2i(min_col, cell_row), 0, Vector2i(1, chunk_type))
		obstacle_layer.set_cell(Vector2i(max_col, cell_row), 0, Vector2i(1, chunk_type))
		for i in range(min_col + 1, max_col):
			if randf() < tree_rate:
				obstacle_layer.set_cell(Vector2i(i, cell_row), 0, Vector2i(1, chunk_type))
				
	elif chunk_type == ChunkType.ROAD:
		for i in range(min_col, max_col + 1):
			if i % 2 == 0 and row_num_relative % 2 == 0:
				ground_layer.set_cell(Vector2i(i, cell_row), 0, Vector2i(2, chunk_type))
			elif i % 2 == 0 and row_num_relative % 2 == 1:
				ground_layer.set_cell(Vector2i(i, cell_row), 0, Vector2i(0, chunk_type))
			elif i % 2 == 1 and row_num_relative % 2 == 0:
				ground_layer.set_cell(Vector2i(i, cell_row), 0, Vector2i(3, chunk_type))
			elif i % 2 == 1 and row_num_relative % 2 == 1:
				ground_layer.set_cell(Vector2i(i, cell_row), 0, Vector2i(1, chunk_type))
		
		var l_or_r = randi_range(0, 1)
		var spawn_x = max_col if l_or_r == 0 else min_col
		var dir = -1 if l_or_r == 0 else 1
		
		var pos: Vector2 = obstacle_layer.map_to_local(Vector2i(spawn_x, cell_row))
		pos = to_local(obstacle_layer.to_global(pos))
		var obj: Spawner = car_spawner.instantiate()
		call_deferred("add_child", obj)
		obj.position = pos
		obj.direction = dir
		obj.spawner_lower_bound = spawner_lower_bound
		
		obj.speed = [0.01, 0.02, 0.04, 0.05].pick_random()
		
	elif chunk_type == ChunkType.WATER:
		for i in range(min_col, max_col + 1):
			ground_layer.set_cell(Vector2i(i, cell_row), 0, Vector2i(0, chunk_type))
		
		var l_or_r = randi_range(0, 1)
		var spawn_x = max_col + 1 if l_or_r == 0 else min_col - 1
		var dir = -1 if l_or_r == 0 else 1
		
		var pos: Vector2 = obstacle_layer.map_to_local(Vector2i(spawn_x, cell_row))
		pos = to_local(obstacle_layer.to_global(pos))
		var obj: Spawner = log_spawner.instantiate()
		call_deferred("add_child", obj)
		obj.position = pos
		obj.speed = [0.25, 0.5, 0.75, 1, 1.25].pick_random()
		obj.spawner_lower_bound = spawner_lower_bound
		obj.direction = dir


## Equivalent to moving the player up one tile. But moves the whole tileset instead to 
## keep the player's position in the screen fixed.
## TODO: Teleport the entire map and map elements past a certain point to prevent overflow
func raise_tiles() -> void:
	accum += 1
	if accum == next_chunk:
		for j in range(accum):
			# Iterate through rows of accum to gen
			min_row -= 1
			
			# Generate rows
			gen_row(min_row - tilemap_height, next_chunk_type, j)
			
			# Clear bottom n rows
			for i in range(min_col, max_col + 1):
				ground_layer.set_cell(Vector2i(i, min_row))
		accum = 0
		randomize_chunk()
	pass


## Functionally equivalent to moving the player down one tile
func lower_tiles() -> void:
	accum -= 1


## Shortcut function for converting a global position g_pos to a tile_map posititon
func to_tile_pos(g_pos: Vector2) -> Vector2i:
	return ground_layer.local_to_map(ground_layer.to_local(g_pos))
