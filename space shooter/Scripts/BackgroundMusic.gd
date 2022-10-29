extends Node2D

func play(songname: String) -> void:
	
	for node in get_children():
		if node is AudioStreamPlayer:
			node.stop()
	
	get_node(songname).play()


func change_volume() -> void:
	$GameMusic.volume_db = -20

func reset_volume() -> void:
	$GameMusic.volume_db = -10
	
