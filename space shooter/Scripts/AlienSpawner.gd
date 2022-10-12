extends Node


const WIDTH = 1024
const HEIGHT = 600

var alien_scene = preload("res://Scenes/Alien.tscn")

onready var player = get_parent().get_node("MainShip")
onready var HUD = get_parent().get_node("HUD")

func _ready() -> void:
	randomize()
	$AlienSpawnTimer.wait_time = 3 + rand_range(-2, 2)
	

func _can_spawn_aliens() -> bool:
	var number_of_aliens = len(get_tree().get_nodes_in_group("Enemy"))
	return number_of_aliens <= 10

func _spawn_alien() -> void:
	var alien = alien_scene.instance()
	alien.connect("scoreUpdated", HUD, "scoreUpdated")
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

func _spawn_swarm() -> void:
	#var possible_sections = [[0, 3], [0, 2], [1, 3], [1, 3]]
	#var sections = possible_sections[randi() % len(possible_sections)]
	
	for section in [0, 1, 2, 3]:
		for i in range(3):
			var alien = alien_scene.instance()
			alien.connect("scoreUpdated", HUD, "scoreUpdated")
			if section == 0:
				alien.global_position = player.global_position + Vector2(-WIDTH/2 - 20, -HEIGHT/2 + i * HEIGHT/3)
			elif section == 1:
				alien.global_position = player.global_position + Vector2(WIDTH/2 + 20, -HEIGHT/2 + i * HEIGHT/3)
			elif section == 2:
				alien.global_position = player.global_position + Vector2(-WIDTH/2 + i * WIDTH/3, -HEIGHT/2 - 20)
			else:
				alien.global_position = player.global_position + Vector2(-WIDTH/2 + i * WIDTH/3, HEIGHT/2 + 20)
			add_child(alien)
				
	
func _on_AlienSpawnTimer_timeout() -> void:
	if _can_spawn_aliens():
		var randomnumber = randi() % 10
		if randomnumber == 0:
			_spawn_swarm()
		else:
			_spawn_alien()
		$AlienSpawnTimer.wait_time = 3 + rand_range(-2, 2)
		
