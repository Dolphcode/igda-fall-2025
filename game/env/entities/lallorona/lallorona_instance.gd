extends AnimatableBody2D

@export var pjoint: PinJoint2D
@export var rbody: RigidBody2D

func activate_instance():
	self.visible = true

var all_ready: bool = false

func _ready():
	pass


func _process(delta):
	if not all_ready:
		pjoint.node_a = self.get_path()
		pjoint.node_b = rbody.get_path()
		all_ready = true
	else:
		rbody.freeze = false
		position = get_parent().get_node("Camera2D").position
		


func _physics_process(delta):
	pass
