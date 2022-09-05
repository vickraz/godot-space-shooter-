extends Sprite


const SPEED = 400

var direction := Vector2.RIGHT 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Ger skeppet en startposition
	global_position = Vector2(300, 400)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	global_position += direction * SPEED * delta
	
	if global_position.x > 1000 or global_position.x < 100:
		direction *= -1
		
		rotation = direction.angle()
