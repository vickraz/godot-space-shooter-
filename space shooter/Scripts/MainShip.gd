extends KinematicBody2D

const ACCELERATION = 1500

var max_velocity := 500
var direction := Vector2.RIGHT
var velocity = Vector2.ZERO

var can_boost := true

func _ready() -> void:
	#Startposition på skärmen
	global_position = Vector2(300, 300)

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("boost") and can_boost:
		max_velocity = 800
		can_boost = false
		$BoostTimer.start()
	
	_move_ship(delta)
	
	_update_boosters()
	

func _move_ship(delta: float) -> void:
	if Input.is_action_pressed("move") and global_position.distance_to(get_global_mouse_position()) > 30:
		var desired_velocity := direction.rotated(rotation) * max_velocity
		velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	
	velocity = move_and_slide(velocity)
	
func _update_boosters() -> void:
	pass

func _rotate_ship() -> void:
	pass
	
#Anropas automatiskt då timern tar slut
func _on_BoostTimer_timeout() -> void:
	can_boost = true
	max_velocity = 500
