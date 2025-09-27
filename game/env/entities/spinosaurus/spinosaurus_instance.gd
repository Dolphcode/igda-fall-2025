extends Sprite2D

class_name SpinosaurusInstance


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	modulate.a = 0
	print(modulate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a += delta / 255.0 * 10
