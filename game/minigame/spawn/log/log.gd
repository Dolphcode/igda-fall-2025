extends Spawnable
## The Log object which is responsible for moving itself along a river given a 
## speed (which in this case represents the time per move) and direction.
## It also emits a signal to signal to the player that the player should be moved 
## with the log
class_name Log

## Used to signal to the player that this log has moved
signal on_log_move

@export_category("Log Config")
## The tile position of the origin of the log (the leftmost)
@export var tile_pos: Vector2i
@export var min_body_size: int = 1
@export var max_body_size: int = 4

# State
var body_size: int = 1
var tile_size: int
var move_time: float = 0

var accum_position: Vector2

@onready var game_manager: GameManager = get_tree().root.get_node("Game")

func _init():
	# Select body size, must be done on init so it can be accessed by the spawner
	body_size = randi_range(min_body_size, max_body_size)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize time to move
	move_time = speed
	
	# Initialize accum position
	accum_position = position
	
	# Build the log by duplicating the base sprite and positioning correctly
	tile_size = get_parent().get_node("%Map").tile_size
	var base_sprite = $Sprite2D
	for i in range(1, body_size):
		var sprite_copy = base_sprite.duplicate()
		call_deferred("add_child", sprite_copy)
		sprite_copy.position.x = i * tile_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move the log every frame
	move_time -= delta
	if move_time <= 0:
		move_time = speed
		tile_pos.x += direction
		#position.x  += direction * tile_size
		accum_position.x += direction * tile_size
		on_log_move.emit()
	
	
	var step = direction * game_manager.max_move_steps * roundi((1 - (move_time / speed)) * game_manager.get_node("%Map").tile_size / game_manager.max_move_steps)
	position.x = accum_position.x + step
	position.y = accum_position.y
