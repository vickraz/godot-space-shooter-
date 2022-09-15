extends KinematicBody2D


const MAX_VELOCITY = 350
const ACCELERATION = 500

var velocity := Vector2.ZERO

var player = null

func _ready() -> void:
	player = get_node("/root/World/MainShip")
	
func _physics_process(delta: float) -> void:
	if player == null:
		return
	else:
		var direction_to_player = player.global_position - global_position
		var desired_velocity = direction_to_player.normalized() * MAX_VELOCITY
		velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
		
		velocity = move_and_slide(velocity)
		

#Anropas av en bullet vid kollision
func die() -> void:
	queue_free()
	




func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.take_damage(25)
		queue_free()
