extends Control

onready var layer1 = $ParallaxBackground/ParallaxLayer
onready var layer2 = $ParallaxBackground/ParallaxLayer2
onready var layer3 = $ParallaxBackground/ParallaxLayer3

onready var explosion_scene = preload("res://Scenes/BulletExplosion.tscn")

func _process(delta: float) -> void:
	layer1.motion_offset.x += 10*delta
	layer2.motion_offset.x += 20*delta
	layer3.motion_offset.x += 30*delta
	
	if Input.is_action_just_pressed("shoot"):
		var explosion = explosion_scene.instance()
		explosion.global_position = get_global_mouse_position()
		explosion.emitting = true
		add_child(explosion)
		
	
func _on_ButtonStart_pressed() -> void:
	Transition.load_scene("res://Scenes/World.tscn")



func _on_ButtonQuit_pressed() -> void:
	get_tree().quit()

