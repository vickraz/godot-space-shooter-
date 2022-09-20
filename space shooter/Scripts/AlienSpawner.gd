extends Node


const WIDTH = 1024
const HEIGHT = 600

var alien_scene = preload("res://Scenes/Alien.tscn")

onready var player = get_parent().get_node("MainShip")

func _ready() -> void:
	randomize()
	$AlienSpawnTimer.wait_time = 3 + rand_range(-2, 2)
	

func _can_spawn_aliens() -> bool:
	var number_of_aliens = len(get_tree().get_nodes_in_group("Enemy"))
	return number_of_aliens <= 10

func _spawn_alien() -> void:
	var alien = alien_scene.instance()
	
	var section = randi() % 4
	if section == 0:
		alien.global_position = player.global_position + Vector2(-WIDTH/2 - 20, rand_range(-HEIGHT/2, HEIGHT/2))
	elif section == 1:
		alien.global_position = player.global_position + Vector2(WIDTH/2 + 20, rand_range(-HEIGHT/2, HEIGHT/2))
	elif section == 2:
		alien.global_position = player.global_position + Vector2(rand_range(-WIDTH/2, WIDTH/2), -HEIGHT/2 - 20)
	else:
		alien.global_position = player.global_position + Vector2(rand_range(-WIDTH/2, WIDTH/2), HEIGHT/2 + 20)
	add_child(alien)

	
func _on_AlienSpawnTimer_timeout() -> void:
	if _can_spawn_aliens():
		_spawn_alien()
		$AlienSpawnTimer.wait_time = 3 + rand_range(-2, 2)
		
