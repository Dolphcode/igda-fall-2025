extends Area2D
## The spawnable class from which Car and Log derive
class_name Spawnable

@export_category("Movement Config")
@export var direction: int = 1
@export var speed: float = 10.0
