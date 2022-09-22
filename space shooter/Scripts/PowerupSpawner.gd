extends Node


const DISPLACEMENT = 1000
const WIDTH = 1024
const HEIGHT = 600

var can_place_energy_stone = true

onready var player = get_parent().get_node("MainShip")

var energy_stone_scene = preload("res://Scenes/ShieldEnergyStone.tscn")

func _ready() -> void:
	randomize()
	

func _on_EnergyStone_pickup() -> void:
	if player.shield_energy < 100:
		$ShieldEnergyTimer.wait_time = rand_range(12, 18)
		$ShieldEnergyTimer.start()


func _on_ShieldEnergyTimer_timeout() -> void:
	var stone = energy_stone_scene.instance()
	stone.connect("pickup", self, "_on_EnergyStone_pickup")
	var section = randi() % 4
	#placerar stenen på skärmen med hjälp av global_position
	if section == 0:
		pass
	elif section == 1:
		pass
	elif section == 2:
		pass
	else:
		pass
	add_child(stone)
	


func _on_MainShip_hit() -> void:
	if can_place_energy_stone:
		$ShieldEnergyTimer.wait_time = rand_range(8, 15)
		$ShieldEnergyTimer.start()
		can_place_energy_stone = false
