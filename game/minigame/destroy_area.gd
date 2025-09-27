extends Area2D
## Simple object shredder

func _on_area_entered(area):
	area.queue_free()
