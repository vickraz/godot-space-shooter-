extends KinematicBody2D

var speed = 400 


func _physics_process(delta: float) -> void:
	
	#Direktionsvektor från input actions. 
	#Direktionsvektorn kommer alltid att vara normaliserad dvs ha längden 1
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var velocity = direction * speed
	
	#KinematicBody2D har en inbyggd funktion som hanterar rörelse och 
	#kollisioner i ett. Tiden delta används också automatiskt
	velocity = move_and_slide(velocity)
	
	
	if velocity != Vector2.ZERO:
		rotation = velocity.angle()
