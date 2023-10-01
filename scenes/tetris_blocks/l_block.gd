extends BaseTetromino

func _ready():
	blocks_start_position = [Vector2.ZERO,Vector2.UP,Vector2.UP * 2, Vector2.RIGHT ]
	block_tint = Color(1, .75, .75)
	_on_ready()
