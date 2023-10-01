extends BaseTetromino



# Called when the node enters the scene tree for the first time.
func _ready():
	offset = Vector2(32, -64)
	for child in $Blocks.get_children():
		child.get_child(1).modulate = Color(0.5, .5, 1)

