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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# We can onl
	if tile_offset.y == 0:
		if Input.is_action_just_pressed("ui_up"):
			tile_offset.y -= 1
		if Input.is_action_just_pressed("ui_down"):
			tile_offset.y += 1
	if tile_offset.x == 0:
		if Input.is_action_just_pressed("ui_left"):
			tile_offset.x -= 1
		if Input.is_action_just_pressed("ui_right"):
			tile_offset.x += 1
	
