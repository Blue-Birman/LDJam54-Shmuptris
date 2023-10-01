extends BaseTetromino

func _ready():
	blocks_start_position =  [Vector2.ZERO,Vector2.LEFT,Vector2.DOWN,Vector2.RIGHT]
	block_tint = Color(1, .5, 1)
	_on_ready()

