extends Area2D
## Simple object shredder

func _on_area_entered(area: Area2D):
	if (not area.get_parent().is_in_group("player")) and (not area.is_in_group("shredder")):

		area.queue_free()
