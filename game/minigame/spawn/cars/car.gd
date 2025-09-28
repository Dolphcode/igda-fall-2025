extends Spawnable
## The car object responsible for moving itself along the road and detecting 
## the player to trigger game over.
class_name Car


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += self.direction * self.speed


func _on_body_entered(body):
	if body.get_parent().is_in_group("player"):
		get_tree().root.get_node("Game").lose_game()


func _on_area_entered(area):
	if area.get_parent().is_in_group("player"):
		get_tree().root.get_node("Game").lose_game()
