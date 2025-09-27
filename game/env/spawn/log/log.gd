extends Area2D
class_name Log


signal on_log_move

var tile_pos: Vector2i
var body_size: int = 1

var speed = 0.5
var direction = 1

var move_time = 0

var tile_size

# Called when the node enters the scene tree for the first time.
func _ready():
	body_size = randi_range(1, 4)
	move_time = speed
	
	tile_size = get_parent().get_node("%Map").tile_size
	var obj = $Sprite2D
	for i in range(1, body_size):
		var obj2 = obj.duplicate()
		call_deferred("add_child", obj2)
		obj2.position.x = i * tile_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_time -= delta
	if move_time <= 0:
		move_time = speed
		tile_pos.x += direction
		position.x += direction * tile_size
		on_log_move.emit()
