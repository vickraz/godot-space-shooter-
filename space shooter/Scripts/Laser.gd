extends Line2D


signal laser_deactivated
signal laser_activated(nodepath)

var laser_active := false
var out_of_energy := false
var time_left := 2.0

onready var timer = $EnergyTimer
onready var raycast = $RayCast2D
onready var beamparticles = $BeamParticles

var laser_explosion_scene = preload("res://Scenes/LaserExplosion.tscn")

func _ready() -> void:
	visible = false
	raycast.enabled = false
	points[1] = Vector2.ZERO
	emit_signal("laser_activated", self)

func _physics_process(delta: float) -> void:
	time_left = _set_time_left()
	if Input.is_action_pressed("shoot"):
		if not laser_active and not out_of_energy:
			_appear()
	
		beamparticles.position = points[1] / 2
		beamparticles.emission_rect_extents.x = points[1].length() / 2
		raycast.cast_to = points[1]
		raycast.force_raycast_update()
		if raycast.is_colliding():
			var body = raycast.get_collider()
			body.die()
			points[1] = to_local(raycast.get_collision_point())
			_add_explosion(raycast.get_collision_point())
			
		else:
			points[1] = points[1].move_toward(Vector2(600, 0), 5000 * delta)
	
	elif laser_active and not out_of_energy:
		_disappear()


func _appear() -> void:
	laser_active = true
	#Spela animation
	$AnimationPlayer.play("appear")
	if timer.paused:
		timer.paused = false
	else:
		timer.start()


func _disappear() -> void:
	laser_active = false
	$AnimationPlayer.play("disappear")
	
	

func _on_EnergyTimer_timeout() -> void:
	out_of_energy = true
	$AnimationPlayer.play("outOfEnergy")


#Anropas från AnimationPlayer då "outOfEnergy" spelats klart
func _deactivate_Laser() -> void:
	emit_signal("laser_deactivated")
	queue_free()


#Anropas via AnimationPlayer då "disappear" är klar
func _pause_timer() -> void:
	timer.paused = true
	
func _set_time_left() -> float:
	if not out_of_energy:
		if timer.time_left:
			return timer.time_left
		else:
			return 2.0
	else:
		return 0.0

func _add_explosion(pos: Vector2) -> void:
	var explosion = laser_explosion_scene.instance()
	explosion.global_position = pos
	explosion.global_rotation = global_rotation
	explosion.emitting = true
	get_tree().get_root().add_child(explosion)
