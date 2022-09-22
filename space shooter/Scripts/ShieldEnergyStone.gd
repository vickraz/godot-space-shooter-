extends Area2D


signal pickup




func _on_ShieldEnergyStone_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("pickup")
		body.pick_up("energystone")
		queue_free()
