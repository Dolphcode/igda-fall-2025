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

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var tile_size: int = ground_layer.tile_set.tile_size.x

# State
var accum: int = 0
var next_chunk: int = 0
var next_chunk_type: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_chunk()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func randomize_chunk():
	next_chunk = randi_range(min_chunk_height, max_chunk_height)
	next_chunk_type = randi_range(1, 3)


func raise_tiles():
	accum += 1
	print(accum)
	if accum == next_chunk:
		for j in range(accum):
			min_row -= 1
			for i in range(min_col, max_col + 1):
				ground_layer.set_cell(Vector2i(i, min_row - tilemap_height), 0, Vector2i(0, next_chunk_type))
				ground_layer.set_cell(Vector2i(i, min_row))
		accum = 0
		randomize_chunk()
	pass


func lower_tiles():
	accum -= 1
