extends Node

class_name SpinosaurusSpawner


@export var spinosaurus_inst: PackedScene

## Time between spawn attempts
var spawn_time: float = 5

## Time to the next spawn attempt
var tt_spawn_att: float = 0

# Onready
@onready var window_man: WindowManager = get_parent().get_node("%WindowManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	tt_spawn_att = spawn_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tt_spawn_att -= delta
	if tt_spawn_att <= 0:
		print("spawn")
		tt_spawn_att = spawn_time
		var view: EnvView = window_man.env_views.pick_random()
		var spinosaurus: SpinosaurusInstance = spinosaurus_inst.instantiate()
		var scale = view.size.x / spinosaurus.texture.get_size().x
		spinosaurus.scale = Vector2(scale, scale)
		spinosaurus.position = view.camera.position
		get_parent().call_deferred("add_child", spinosaurus)
		
