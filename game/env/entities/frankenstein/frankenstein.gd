extends Node
class_name Frankenstein

enum F_Orientation {
	TOPDOWN,
	SIDEWAYS,
	TOPDOWN_R,
	SIDEWAYS_R
}


var frankenstein_active: bool = false

# Onready
@onready var window_man: WindowManager = get_parent().get_node("%WindowManager")

var head_window: EnvView
var body_window: EnvView
var leg_window: EnvView
var curr_orientation: F_Orientation


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var r: bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not r:
		engage_frankenstein()
		r = true
		
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
		


func configure_frankenstein_texture(t: TextureRect, r: float, c: Color):
	t.pivot_offset = t.size / 2
	t.rotation = r
	t.modulate = c


func engage_frankenstein():
	frankenstein_active = true
	
	window_man.env_views.shuffle()
	head_window = window_man.env_views[0]
	body_window = window_man.env_views[1]
	leg_window = window_man.env_views[2]
	
	curr_orientation = randi_range(0, 4)
	
	# Sample setup
	
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
	configure_frankenstein_texture(head_window.get_node("Frankenstein/TextureRect"), rotation, Color.RED)
	configure_frankenstein_texture(body_window.get_node("Frankenstein/TextureRect"), rotation, Color.GREEN)
	configure_frankenstein_texture(leg_window.get_node("Frankenstein/TextureRect"), rotation, Color.BLUE)


func disengage_frankenstein():
	head_window.get_node("Frankenstein").visible = false
	body_window.get_node("Frankenstein").visible = false
	leg_window.get_node("Frankenstein").visible = false
	frankenstein_active = false
