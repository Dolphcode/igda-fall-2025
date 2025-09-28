extends Spawnable
## The car object responsible for moving itself along the road and detecting 
## the player to trigger game over.
class_name Car

var accum: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	accum += delta
	if accum >= speed:
		accum = 0
		position.x += self.direction * get_tree().root.get_node("Game").max_move_steps


func _on_area_entered(area):
	if area.get_parent().is_in_group("player"):
		get_tree().root.get_node("Game").lose_game("Car")
