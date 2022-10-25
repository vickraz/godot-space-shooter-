extends CanvasLayer

const SAVE_FILE_PATH = "user://KamikazeAliensSaveFile.save"

var score: int = 0
var highscore: int

onready var shieldbar = $ShieldBar
onready var scoretext = $ScoreText
onready var highscoretext = $HighscoreText
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
	_load_highscore(SAVE_FILE_PATH)
	highscoretext.text = "Highscore: " + str(highscore)

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

func _load_highscore(FILE_PATH) -> void:
	var save_file = File.new()
	if save_file.file_exists(FILE_PATH):
		save_file.open(FILE_PATH, File.READ)
		highscore = save_file.get_var()
		save_file.close()
	else:
		highscore = 0

func _save_highscore(FILE_PATH) -> void:
	var save_file = File.new()
	save_file.open(FILE_PATH, File.WRITE)
	save_file.store_var(score)
	save_file.close()


func _on_MainShip_game_over() -> void:
	if score > highscore:
		_save_highscore(SAVE_FILE_PATH)
	
	yield(get_tree().create_timer(0.7), "timeout")
	Shake.shake_nodes = {}
	Transition.load_scene("res://Scenes/MainMenu.tscn")
