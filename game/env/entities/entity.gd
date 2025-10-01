extends Node
class_name Entity


@export_category("Generic Entity Config")
@export var entity_active: bool = false

## Enable an entity
func enable_entity():
	entity_active = true


## TODO: Implement some form of difficulty progression for entities
func progress_entity():
	pass


## OVERRIDE THIS FUNCTION
func _ent_process(_delta):
	pass


func _process(delta):
	if entity_active:
		_ent_process(delta)
