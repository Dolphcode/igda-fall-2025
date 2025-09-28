extends Area2D
## Simple object shredder

func _on_area_entered(area: Area2D):
	if area.get_parent().is_in_group("player"):
		get_tree().root.get_node("Game").lose_game("Boundaries")
