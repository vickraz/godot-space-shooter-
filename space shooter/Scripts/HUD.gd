extends CanvasLayer

var score: int = 0

onready var shieldbar = $ShieldBar
onready var scoretext = $ScoreText
onready var laserbar = $LaserBar
onready var laserbarunder = $LaserBarUnder
onready var shieldbarunder = $ShieldBarUnder
onready var tween = $Tween

var laser = null

func _ready() -> void:
	shieldbar.value = 100
	shieldbarunder.value = 100
	laserbar.value = 0
	laserbarunder.visible = false
	laserbar.visible = false
	scoretext.text = "Score: " + str(score)
	Shake.shake_nodes[self] = false

func _process(delta: float) -> void:
	if laser:
		laserbar.value = move_toward(laserbar.value, 100* laser.time_left / 2, 2)
		laserbarunder.value = 100*laser.time_left/2

#Signal från MainShip som meddelar den nuvarande skölden
func _on_MainShip_shieldEnergyChanged(shield_energy) -> void:
	if shieldbar.value > shield_energy:
		#minskning
		if shield_energy == 0:
			$AnimationPlayerShield.play("shieldLevelCritical")
		shieldbar.value = shield_energy
		tween.stop_all()
		tween.interpolate_property(shieldbarunder, "value", shieldbarunder.value, shield_energy, 0.5, Tween.TRANS_LINEAR)
		tween.start()
	else:
		#ökning
		shieldbarunder.value = shield_energy
		tween.stop_all()
		tween.interpolate_property(shieldbar, "value", shieldbar.value, shield_energy, 0.5, Tween.TRANS_LINEAR)
		tween.start()
		$AnimationPlayerShield.play("RESET")
		


#Uppdateras då signal från Alien mottas (connectas i AlienSpawner)
func _scoreUpdated(amount) -> void:
	score += amount
	scoretext.text = "Score: " + str(score)

#Signal från lasern då lasern aktiveras
func _activate_laser(nodepath) -> void:
	$AnimationPlayer.play("laserbarsAppear")
	laser = nodepath

#Signal från lasern då den avaktiveras
func _deactivate_laser() -> void:
	$AnimationPlayer.play("laserbarsDisappear")
	laser = null

