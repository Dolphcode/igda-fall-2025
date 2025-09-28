extends Node
class_name Frankenstein

enum F_Orientation {
	TOPDOWN,
	SIDEWAYS,
	TOPDOWN_R,
	SIDEWAYS_R
}

@export_category("Difficulty Config")
@export var spawn_time: float = 15

@export_category("Visuals")
@export var head_tex: Texture2D
@export var bod_tex: Texture2D
@export var leg_tex: Texture2D

# State
var frankenstein_active: bool = false

# Onready
@onready var window_man: WindowManager = get_parent().get_node("%WindowManager")

var head_window: EnvView
var body_window: EnvView
var leg_window: EnvView
var curr_orientation: F_Orientation



var spawn_counter: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not frankenstein_active:
		spawn_counter += delta
		if spawn_counter >= spawn_time:
			# Attempt to engage frankenstein
			engage_frankenstein()
			spawn_counter = 0
		
	if frankenstein_active:
		var orientation_correct: bool = false
		
		var fixed_axes: Array = [0, 0, 0]
		var test_axes: Array = [0, 0, 0]
		if curr_orientation == F_Orientation.TOPDOWN || curr_orientation == F_Orientation.TOPDOWN_R:
			fixed_axes[0] =  head_window.get_node("Camera2D").position.x
			fixed_axes[1] =  body_window.get_node("Camera2D").position.x
			fixed_axes[2] =  leg_window.get_node("Camera2D").position.x
			test_axes[0] =  head_window.get_node("Camera2D").position.y
			test_axes[1] =  body_window.get_node("Camera2D").position.y
			test_axes[2] =  leg_window.get_node("Camera2D").position.y
		else:
			fixed_axes[0] =  head_window.get_node("Camera2D").position.y
			fixed_axes[1] =  body_window.get_node("Camera2D").position.y
			fixed_axes[2] =  leg_window.get_node("Camera2D").position.y
			test_axes[0] =  head_window.get_node("Camera2D").position.x
			test_axes[1] =  body_window.get_node("Camera2D").position.x
			test_axes[2] =  leg_window.get_node("Camera2D").position.x
		
		var padding: float = head_window.size.x * 0.25
		var dist: float = head_window.size.x
		
		if curr_orientation == F_Orientation.TOPDOWN || curr_orientation == F_Orientation.SIDEWAYS:
			var v_dist1 = test_axes[2] - test_axes[1]
			var v_dist2 = test_axes[1] - test_axes[0]
			var threshold_1 = abs(fixed_axes[2] - fixed_axes[1])
			var threshold_2 = abs(fixed_axes[0] - fixed_axes[1])
			orientation_correct = threshold_1 < padding and threshold_2 < padding and abs(v_dist1 - dist) < padding and abs(v_dist2 - dist) < padding
		else:
			var v_dist1 = test_axes[0] - test_axes[1]
			var v_dist2 = test_axes[1] - test_axes[2]
			var threshold_1 = abs(fixed_axes[2] - fixed_axes[1])
			var threshold_2 = abs(fixed_axes[0] - fixed_axes[1])
			orientation_correct = threshold_1 < padding and threshold_2 < padding and abs(v_dist1 - dist) < padding and abs(v_dist2 - dist) < padding
		
		if orientation_correct:
			disengage_frankenstein()
		


func configure_frankenstein_texture(t: TextureRect, r: float, tx: Texture2D):
	t.pivot_offset = t.size / 2
	t.rotation = r
	t.texture = tx


func engage_frankenstein():
	window_man.env_views.shuffle()
	var free_windows = 0
	for i in window_man.env_views:
		if i.cerberus_active():
			continue
		else:
			if free_windows == 0:
				head_window = i
				free_windows += 1
			elif free_windows == 1:
				body_window = i
				free_windows += 1
			else:
				leg_window = i
				free_windows += 1
				break
	
	# Failure to find enough windows for frankenstein to occupy
	if free_windows != 3:
		return
	
	# Occupy windows
	frankenstein_active = true
	head_window.frankenstein_occupied = true
	body_window.frankenstein_occupied = true
	leg_window.frankenstein_occupied = true
	
	curr_orientation = randi_range(0, 3) as F_Orientation
	
	head_window.get_node("Frankenstein").visible = true
	body_window.get_node("Frankenstein").visible = true
	leg_window.get_node("Frankenstein").visible = true
	
	var rotation = 0
	match(curr_orientation):
		F_Orientation.TOPDOWN:
			rotation = deg_to_rad(0)
		F_Orientation.TOPDOWN_R:
			rotation = deg_to_rad(180)
		F_Orientation.SIDEWAYS:
			rotation = deg_to_rad(270)
		F_Orientation.SIDEWAYS_R:
			rotation = deg_to_rad(90)
	configure_frankenstein_texture(head_window.get_node("Frankenstein/TextureRect"), rotation, head_tex)
	configure_frankenstein_texture(body_window.get_node("Frankenstein/TextureRect"), rotation, bod_tex)
	configure_frankenstein_texture(leg_window.get_node("Frankenstein/TextureRect"), rotation, leg_tex)


func disengage_frankenstein():
	head_window.frankenstein_occupied = false
	body_window.frankenstein_occupied = false
	leg_window.frankenstein_occupied = false
	head_window.get_node("Frankenstein").visible = false
	body_window.get_node("Frankenstein").visible = false
	leg_window.get_node("Frankenstein").visible = false
	frankenstein_active = false
