extends Node


const DISPLACEMENT = 1100
const WIDTH = 1024
const HEIGHT = 600

var can_place_energy_stone = true

onready var player = get_parent().get_node("MainShip")

var laser_stone_scene = preload("res://Scenes/LaserStone.tscn")
var energy_stone_scene = preload("res://Scenes/ShieldEnergyStone.tscn")

func _ready() -> void:
	randomize()
	$LaserTimer.wait_time = rand_range(2, 3)
	$LaserTimer.start()
	

func _on_EnergyStone_pickup() -> void:
	can_place_energy_stone = true
	if player.shield_energy < 100:
		can_place_energy_stone = false
		$ShieldEnergyTimer.wait_time = rand_range(12, 18)
		$ShieldEnergyTimer.start()

func _on_LaserStone_pickup() -> void:
	$LaserTimer.wait_time = rand_range(10, 18)
	$LaserTimer.start()


func _on_ShieldEnergyTimer_timeout() -> void:
	var stone = energy_stone_scene.instance()
	stone.connect("pickup", self, "_on_EnergyStone_pickup")
	var section = randi() % 4
	#placerar stenen på skärmen med hjälp av global_position
	if section == 0:
		stone.global_position = player.global_position + Vector2(-DISPLACEMENT, rand_range(-HEIGHT/2, HEIGHT/2))
	elif section == 1:
		stone.global_position = player.global_position + Vector2(DISPLACEMENT, rand_range(-HEIGHT/2, HEIGHT/2))
	elif section == 2:
		stone.global_position = player.global_position + Vector2(rand_range(-WIDTH/2, WIDTH/2), DISPLACEMENT)
	else:
		stone.global_position = player.global_position + Vector2(rand_range(-WIDTH/2, WIDTH/2), -DISPLACEMENT)
	
	add_child(stone)
	


func _on_MainShip_hit() -> void:
	if can_place_energy_stone:
		$ShieldEnergyTimer.wait_time = rand_range(8, 15)
		$ShieldEnergyTimer.start()
		can_place_energy_stone = false


func _on_LaserTimer_timeout() -> void:
	var stone = laser_stone_scene.instance()
	stone.connect("pickup", self, "_on_LaserStone_pickup")
	var section = randi() % 4
	if section == 0:
		stone.global_position = player.global_position + Vector2(-DISPLACEMENT, rand_range(-HEIGHT/2, HEIGHT/2))
	elif section == 1:
		stone.global_position = player.global_position + Vector2(DISPLACEMENT, rand_range(-HEIGHT/2, HEIGHT/2))
	elif section == 2:
		stone.global_position = player.global_position + Vector2(rand_range(-WIDTH/2, WIDTH/2), DISPLACEMENT)
	else:
		stone.global_position = player.global_position + Vector2(rand_range(-WIDTH/2, WIDTH/2), -DISPLACEMENT)
	
	add_child(stone)
