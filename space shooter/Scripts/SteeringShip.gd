extends KinematicBody2D

const ACCELERATION = 1500
var speed := 400 
var velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	
	#Direktionsvektor från input actions. 
	#Direktionsvektorn kommer alltid att vara normaliserad dvs ha längden 1
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var desired_velocity := direction * speed
	
	velocity = velocity.move_toward(desired_velocity, ACCELERATION*delta)
	
	#KinematicBody2D har en inbyggd funktion som hanterar rörelse och 
	#kollisioner i ett. Tiden delta används också automatiskt
	velocity = move_and_slide(velocity)
	
	
	if velocity != Vector2.ZERO:
		rotation = velocity.angle()
