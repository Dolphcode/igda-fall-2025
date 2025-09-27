extends Sprite2D

class_name SpinosaurusInstance


var screens_on: int = 0

var lifetime: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	modulate.a = 0
	print(modulate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a += delta / 255.0 * 10
	if screens_on == 0:
		lifetime -= delta
		
	if lifetime <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	screens_on += 1


func _on_visible_on_screen_notifier_2d_screen_exited():
	screens_on -= 1
