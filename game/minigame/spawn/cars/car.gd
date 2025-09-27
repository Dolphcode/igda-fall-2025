extends Spawnable
## The car object responsible for moving itself along the road and detecting 
## the player to trigger game over.
class_name Car


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += self.direction * self.speed
