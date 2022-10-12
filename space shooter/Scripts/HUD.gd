extends CanvasLayer

var score: int = 0

onready var shieldbar = $ShieldBar
onready var scoretext = $ScoreText
onready var tween = $Tween

func _ready() -> void:
	shieldbar.value = 100
	scoretext.text = "Score: " + str(score)



#Signal från MainShip som meddelar den nuvarande skölden
func _on_MainShip_shieldEnergyChanged(shield_energy) -> void:
	tween.interpolate_property(shieldbar, "value", shieldbar.value, shield_energy, 0.5, Tween.TRANS_LINEAR)
	tween.start()


#Uppdateras då signal från Alien mottas (connectas i AlienSpawner)
func scoreUpdated(amount) -> void:
	score += amount
	scoretext.text = "Score: " + str(score)
