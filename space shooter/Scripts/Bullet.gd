extends Area2D

const VELOCITY = 2000

#Kommer ändras från MainShip då Bullets instansieras
var direction := Vector2.ZERO

func _ready() -> void:
	$LifeTimer.start()

func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	
	else:
		global_position += direction * VELOCITY * delta

#Anropas av MainShip då Bullet-instanser skapas
func set_direction(pos1: Vector2, pos2: Vector2) -> void:
	direction = (pos2 - pos1).normalized()
	rotation = direction.angle()
	

#Anropas automatiskt av spelmotorn
func _on_LifeTimer_timeout() -> void:
	queue_free()
