extends Particles2D

func _process(delta: float) -> void:
	if emitting == false:
		queue_free()
