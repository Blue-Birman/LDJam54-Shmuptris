extends BaseTetromino

func _ready():
	blocks_start_position = [Vector2.ZERO,Vector2.UP,Vector2.UP * 2, Vector2.LEFT ]
	block_tint = Color(.5, .5, 1)
	_on_ready()
