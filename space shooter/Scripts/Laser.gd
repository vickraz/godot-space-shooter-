extends Line2D


signal laser_deactivated

var laser_active = false

onready var timer = $EnergyTimer
onready var raycast = $RayCast2D
onready var beamparticles = $BeamParticles

func _ready() -> void:
	visible = false
	raycast.enabled = false
	points[1] = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		if not laser_active:
			_appear()
		
		beamparticles.position = points[1] / 2
		beamparticles.process_material.emission_box_extents.x = points[1].length() / 2
		raycast.cast_to = points[1]
		raycast.force_raycast_update()
		if raycast.is_colliding():
			var body = raycast.get_collider()
			body.die()
			points[1] = to_local(raycast.get_collision_point())
			
		else:
			points[1] = points[1].move_toward(Vector2(600, 0), 5000 * delta)
	
	elif laser_active:
		_disappear()


func _appear() -> void:
	laser_active = true
	#Spela animation
	visible = true
	raycast.enabled = true
	if timer.paused:
		timer.paused = false
	else:
		timer.start()


func _disappear() -> void:
	laser_active = false
	timer.paused = true
	#spela animation
	visible = false
	raycast.enabled = false
	
	

func _on_EnergyTimer_timeout() -> void:
	emit_signal("laser_deactivated")
	queue_free()
