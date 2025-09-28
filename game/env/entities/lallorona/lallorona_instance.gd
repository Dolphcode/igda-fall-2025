extends AnimatableBody2D

@export_category("Visual Parts")
@export var pjoint: PinJoint2D
@export var rbody: RigidBody2D

@export_category("Difficulty Config")
@export var shakes: int = 20
@export var death_time: float = 8

var instance_active: bool = false
var shake_count: int = 0
var death_counter: float = 0
var all_ready: bool = false

func activate_instance():
	shake_count = 0
	death_counter = 0
	instance_active = true
	self.visible = true
	rbody.visible = true


func deactivate_instance():
	instance_active = false
	self.visible = false
	rbody.visible = false


func _process(delta):
	if not all_ready:
		pjoint.node_a = self.get_path()
		pjoint.node_b = rbody.get_path()
		all_ready = true
	else:
		rbody.freeze = false
		position = get_parent().get_node("Camera2D").position
		
		if instance_active:
			death_counter += delta
			if death_counter >= death_time:
				get_tree().root.get_node("Game").lose_game()
			
			if shake_count >= shakes:
				deactivate_instance()
