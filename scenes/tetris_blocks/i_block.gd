extends BaseTetromino

func _ready():
	blocks_start_position = [Vector2.ZERO,Vector2.UP,Vector2.UP * 2,Vector2.DOWN]
	block_tint = Color(.75, .75, 1)
	_on_ready()
