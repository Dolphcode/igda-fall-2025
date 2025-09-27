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
@export_category("Tilemap Size Config")
@export var tilemap_height: int = 40
@export var min_row: int = 40
@export var min_col: int = -1
@export var max_col: int = 32

@export_category("Chunk Config")
@export var min_chunk_height: int = 2
@export var max_chunk_height: int = 7

@export_category("Grass Area Config")
@export var tree_rate: float = 0.4

@export_category("Road Config")
@export var car_spawner: PackedScene

@export_category("Water Config")
@export var log_spawner: PackedScene

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var obstacle_layer: TileMapLayer = $ObstacleLayer
@onready var tile_size: int = ground_layer.tile_set.tile_size.x

# State
var accum: int = 0
var next_chunk: int = 0
var next_chunk_type: int = 0

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func randomize_chunk():
	next_chunk = randi_range(min_chunk_height, max_chunk_height)
	next_chunk_type = randi_range(0, 2)


func gen_row(cell_row: int, chunk_type: int):
	# Fill with terrain
	for i in range(min_col, max_col + 1):
		ground_layer.set_cell(Vector2i(i, cell_row), 0, Vector2i(0, chunk_type))
		
	
	# Implement obstacles if needed
	if chunk_type == ChunkType.GRASS:
		obstacle_layer.set_cell(Vector2i(min_col, cell_row), 0, Vector2i(1, chunk_type))
		obstacle_layer.set_cell(Vector2i(max_col, cell_row), 0, Vector2i(1, chunk_type))
		for i in range(min_col + 1, max_col):
			if randf() < tree_rate:
				obstacle_layer.set_cell(Vector2i(i, cell_row), 0, Vector2i(1, chunk_type))
				
	elif chunk_type == ChunkType.ROAD:
		var pos: Vector2 = obstacle_layer.map_to_local(Vector2i(max_col, cell_row))
		pos = to_local(obstacle_layer.to_global(pos))
		var obj: Spawner = car_spawner.instantiate()
		call_deferred("add_child", obj)
		obj.position = pos
		obj.spawner_lower_bound = spawner_lower_bound
		
	elif chunk_type == ChunkType.WATER:
		var pos: Vector2 = obstacle_layer.map_to_local(Vector2i(max_col, cell_row))
		pos = to_local(obstacle_layer.to_global(pos))
		var obj: Spawner = log_spawner.instantiate()
		call_deferred("add_child", obj)
		obj.position = pos
		obj.spawner_lower_bound = spawner_lower_bound


func raise_tiles():
	accum += 1
	if accum == next_chunk:
		for j in range(accum):
			# Iterate through rows of accum to gen
			min_row -= 1
			
			# Generate rows
			gen_row(min_row - tilemap_height, next_chunk_type)
			
			# Clear bottom n rows
			for i in range(min_col, max_col + 1):
				ground_layer.set_cell(Vector2i(i, min_row))
		accum = 0
		randomize_chunk()
	pass


func lower_tiles():
	accum -= 1


func to_tile_pos(g_pos: Vector2) -> Vector2i:
	return ground_layer.local_to_map(ground_layer.to_local(g_pos))
