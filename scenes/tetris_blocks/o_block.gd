extends BaseTetromino

func _ready():
	blocks_start_position = [Vector2.ZERO,Vector2.UP,Vector2.UP + Vector2.RIGHT, Vector2.RIGHT ]
	block_tint = Color(1, 1, .5)
	_on_ready()
