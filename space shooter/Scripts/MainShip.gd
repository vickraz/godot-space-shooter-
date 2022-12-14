extends KinematicBody2D

signal hit
signal shieldEnergyChanged(shield_energy)
signal game_over

const ACCELERATION = 1500

var max_velocity := 500
var direction := Vector2.RIGHT
var velocity := Vector2.ZERO

var can_boost := true
var can_shoot := true
var can_take_damage := true
var laser_active := false

var bullet_scene = preload("res://Scenes/Bullet.tscn")
var laser_scene = preload("res://Scenes/Laser.tscn")
var pickup_patricles = preload("res://Scenes/PickUpParticles.tscn")
var explosion_scene = preload("res://Scenes/BulletExplosion.tscn")

var shield_energy := 100

onready var HUD = get_parent().get_node("HUD")

func _ready() -> void:
	#Startposition på skärmen
	global_position = Vector2(300, 300)
	$Shield.visible = false
	Shake.shake_nodes[$MainCamera] = true

func _physics_process(delta: float) -> void:
	_rotate_ship()
	
	if Input.is_action_just_pressed("boost") and can_boost:
		max_velocity = 800
		can_boost = false
		$BoostTimer.start()
	
	if Input.is_action_pressed("shoot") and can_shoot and not laser_active:
		_shoot()
	
	_move_ship(delta)
	
	_update_boosters()
	

func _move_ship(delta: float) -> void:
	if Input.is_action_pressed("move") and global_position.distance_to(get_global_mouse_position()) > 30:
		var desired_velocity := direction.rotated(rotation) * max_velocity
		velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	
	move_and_collide(velocity * delta)
	
func _update_boosters() -> void:
	var speed_rate = velocity.length()/500
	
	$ThrusterFlame.scale = Vector2(0.25, 0.25) * speed_rate
	$ThrusterFlame2.scale = Vector2(0.15, 0.15) * speed_rate
	$ThrusterFlame3.scale = Vector2(0.15, 0.15) * speed_rate
	

func _rotate_ship() -> void:
	var desired_rotation = (get_global_mouse_position() - global_position).angle()
	
	rotation = lerp_angle(rotation, desired_rotation, 0.2)
	
func _shoot() -> void:
	$BulletSound.play()
	can_shoot = false
	$ShootTimer.start()
	
	var bullet_instance = bullet_scene.instance()
	bullet_instance.global_position = $Bulletspawn.global_position
	bullet_instance.set_direction($Bulletspawn.global_position, 
	get_global_mouse_position() + direction.rotated(rotation) * 1000)
	
	get_tree().get_root().add_child(bullet_instance)
	
	var bullet_instance2 = bullet_scene.instance()
	bullet_instance2.global_position = $Bulletspawn2.global_position
	bullet_instance2.set_direction($Bulletspawn2.global_position, 
	get_global_mouse_position() + direction.rotated(rotation) * 1000)
	
	get_tree().get_root().add_child(bullet_instance2)
	

#Anropas automatiskt då BoostTimern tar slut
func _on_BoostTimer_timeout() -> void:
	can_boost = true
	max_velocity = 500

#Anropas automatiskt då ShootTimern tar slut
func _on_ShootTimer_timeout() -> void:
	can_shoot = true

func take_damage(amount: int, direction: Vector2) -> void:
	velocity = direction.normalized() * 1000
	if shield_energy == 0 and can_take_damage:
		hide()
		$CollisionPolygon2D.set_deferred("disabled", true)
		var explosion_instance = explosion_scene.instance()
		explosion_instance.global_position = global_position
		explosion_instance.emitting = true
		get_tree().get_root().add_child(explosion_instance)
		emit_signal("game_over")
		Shake.start_shake(7, 0.7)
		set_physics_process(false)
	elif can_take_damage:
		$ForceShieldSound.play()
		emit_signal("hit")
		shield_energy -= amount
		can_take_damage = false
		$AnimationPlayer.play("DamageToShield")
		$Shield.global_rotation = direction.angle() + PI
		emit_signal("shieldEnergyChanged", shield_energy)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "DamageToShield":
		can_take_damage = true
		
func pick_up(item_name: String) -> void:
	var particles = pickup_patricles.instance()
	particles.emitting = true
	add_child(particles)
	if item_name == "energystone":
		shield_energy += 25
		if shield_energy > 100:
			shield_energy = 100
		emit_signal("shieldEnergyChanged", shield_energy)
	elif item_name == "laserstone":
		if laser_active:
			if $Laser.time_left == 2.0:
				pass
			else:
				$Laser/EnergyTimer.start()
				$Laser.time_left = 2.0
		else:
			laser_active = true
			var laser = laser_scene.instance()
			laser.position = $LaserSpawn.position
			laser.connect("laser_deactivated", self, "_deactivate_laser")
			laser.connect("laser_activated", HUD, "_activate_laser")
			laser.connect("laser_deactivated", HUD, "_deactivate_laser")
			add_child(laser)

func _deactivate_laser() -> void:
	laser_active = false
