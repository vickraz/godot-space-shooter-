extends Control



func _on_ButtonStart_pressed() -> void:
	get_tree().change_scene("res://Scenes/World.tscn")



func _on_ButtonQuit_pressed() -> void:
	get_tree().quit()
