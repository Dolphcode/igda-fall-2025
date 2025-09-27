extends Node2D

class_name Spawner

@export_category("Spawner Timing Config")
@export var spawn_time_min: float = 5
@export var spawn_time_max: float = 10

@export_category("Spawn Config")
@export var direction: int = 1
@export var spawnable: PackedScene
@export var spawner_lower_bound: float
@export var tile_pos: Vector2i

var spawn_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_time = randf_range(spawn_time_min, spawn_time_max)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_time -= delta
	if spawn_time <= 0:
		spawn_time = randf_range(spawn_time_min, spawn_time_max)
		var obj = spawnable.instantiate()
		get_parent().call_deferred("add_child", obj)
		obj.position = position
		obj.direction = direction
		if obj is Log:
			obj.tile_pos = tile_pos
		
	if global_position.y > spawner_lower_bound:
		queue_free()
		
