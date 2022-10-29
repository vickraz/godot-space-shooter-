extends Control

onready var layer1 = $ParallaxBackground/ParallaxLayer
onready var layer2 = $ParallaxBackground/ParallaxLayer2
onready var layer3 = $ParallaxBackground/ParallaxLayer3

var explosion1 = preload("res://Scenes/AlienGreenExplosion.tscn")
var explosion2 = preload("res://Scenes/BulletExplosion.tscn")
var explosion3 = preload("res://Scenes/LaserExplosion.tscn")

func _ready() -> void:
	randomize()
	$ScoreLabel.text = "Score: " + str(Globals.score)
	$HighScoreLabel.text = "Highscore: " + str(Globals.highscore)
	
	$NewHighScoreLabel.visible = Globals.new_highscore
	if Globals.new_highscore:
		$FireworksTimer.start()
		$HighscoreSound.play()
	else:
		$GameOverSound.play()
		
		
func _process(delta: float) -> void:
	layer1.motion_offset.x += 10*delta
	layer2.motion_offset.x += 20*delta
	layer3.motion_offset.x += 30*delta



func _on_MainMenuButton_pressed() -> void:
	Transition.load_scene("res://Scenes/MainMenu.tscn")


func _on_FireworksTimer_timeout() -> void:
	var r = randi() % 3
	var x = randi() % 1024
	var y = randi() % 600
	
	if r == 0:
		var explosion = explosion1.instance()
		explosion.global_position = Vector2(x, y)
		explosion.emitting = true
		add_child(explosion)
	elif r == 1:
		var explosion = explosion3.instance()
		explosion.global_position = Vector2(x, y)
		explosion.global_rotation = rand_range(0, 2*PI)
		explosion.emitting = true
		add_child(explosion)
	else:
		var explosion = explosion2.instance()
		explosion.global_position = Vector2(x, y)
		explosion.emitting = true
		add_child(explosion)
		
