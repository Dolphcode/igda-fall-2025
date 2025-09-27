extends CanvasLayer
class_name CerberusInstance

const CHAR_A: int = 65
const CHAR_Z: int = 65 + 25

@export_category("Label Refs")
@export var labels: Array[Label]

# State
var instance_active: bool = false
var characters: Array = [char(0), char(0), char(0)]
var accum: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


## Activates this cerberus instance, the instance deals with reading and deactivating
## after that point.
func activate_instance():
	accum = 0
	instance_active = true
	
	for i in range(3):
		characters[i] = char(randi_range(CHAR_A, CHAR_Z))
		labels[i].text = characters[i]
		print(characters[i])
	
	visible = true


## Deactivates this cerberus instance, turns off the instance_active bool and
## makes it invisible again
func deactivate_instance():
	instance_active = false
	visible = false


func _input(event):
	if (get_parent() as Window).has_focus() and instance_active:
		if event is InputEventKey and event.is_pressed() and event.as_text_key_label() == characters[accum]:
			accum += 1
			if accum >= 3:
				deactivate_instance()
