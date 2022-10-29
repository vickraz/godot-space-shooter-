extends CPUParticles2D


func _ready() -> void:
	$AudioStreamPlayer.play(0.15)

func _process(_delta: float) -> void:
	if emitting == false:
		queue_free()
