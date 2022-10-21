extends Timer


var is_shaking := false
var shake_amount: = 0
var shake_nodes = {}

var noise_y := 0

onready var tween := create_tween().set_parallel(true)

onready var noise = OpenSimplexNoise.new()

func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 3


func _process(delta: float) -> void:
	if is_shaking:
		for node in shake_nodes.keys():
			node.offset.x = shake_amount * noise.get_noise_2d(noise.seed, noise_y)
			node.offset.y = shake_amount * noise.get_noise_2d(noise.seed*2, noise_y)
			if shake_nodes[node]:
				node.rotation = 0.4 * noise.get_noise_2d(noise.seed*3, noise_y)
		noise_y += 1
		
func start_shake(amount, duration) -> void:
	if amount >= shake_amount:
		tween.kill()
		is_shaking = true
		shake_amount = amount
		wait_time = duration
		start()


func _on_Shake_timeout() -> void:
	is_shaking = false
	shake_amount = 0
	noise_y = 0
	for node in shake_nodes.keys():
		tween.tween_property(node, "offset", Vector2.ZERO, 0.1)
		tween.tween_property(node, "rotation", 0, 0.1)
		#node.offset = Vector2.ZERO
		#node.rotation = 0
