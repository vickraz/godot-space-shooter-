extends Area2D

signal pickup

onready var player = get_node("/root/World/MainShip")
onready var indicator = $Indicator

func _process(delta: float) -> void:
	if not $VisibilityNotifier2D.is_on_screen():
		var dir_to_stone = global_position - player.global_position
		indicator.rotation = dir_to_stone.angle()
		indicator.global_position = player.global_position + dir_to_stone.normalized() * 280



func _on_LaserStone_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("pickup")
		body.pick_up("laserstone")
		queue_free()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	indicator.visible = false


func _on_VisibilityNotifier2D_screen_exited() -> void:
	indicator.visible = true
