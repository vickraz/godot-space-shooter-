extends KinematicBody2D


const MAX_VELOCITY = 350
const ACCELERATION = 500

var velocity := Vector2.ZERO
var direction_to_player := Vector2.ZERO

var player = null

var alienGreenExplosion_scene = preload("res://Scenes/AlienGreenExplosion.tscn")
var alienExplosion_scene = preload("res://Scenes/AlienExplosion.tscn")

func _ready() -> void:
	player = get_node("/root/World/MainShip")
	
func _physics_process(delta: float) -> void:
	if player == null:
		return
	else:
		direction_to_player = player.global_position - global_position
		var desired_velocity = direction_to_player.normalized() * MAX_VELOCITY
		velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
		
		velocity = move_and_slide(velocity)
		

#Anropas av en bullet vid kollision
func die() -> void:
	var explosion_instance = alienExplosion_scene.instance()
	explosion_instance.global_position = $Sprite.global_position + Vector2(-80, -50)
	explosion_instance.emitting = true
	explosion_instance.one_shot = true
	
	get_tree().get_root().add_child(explosion_instance)
	queue_free()
	


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.take_damage(25, direction_to_player)
		
		var explosion_instance = alienGreenExplosion_scene.instance()
		explosion_instance.global_position = global_position
		explosion_instance.emitting = true
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
