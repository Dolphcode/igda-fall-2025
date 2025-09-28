extends Sprite2D
## A single instance of the spinosaurus
class_name SpinosaurusInstance

## The rate at which the spinosaurus gets power >:]]]])
var haunt_rate: float = 10.0

# State
var screens_on: int = 0
var lifetime: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if screens_on == 0:
		lifetime -= delta
	modulate.a += delta / 255.0 * haunt_rate
	if modulate.a >= 1.0:
		get_tree().root.get_node("Game").lose_game("Spinosaurus")
		
	if lifetime <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	screens_on += 1


func _on_visible_on_screen_notifier_2d_screen_exited():
	screens_on -= 1
