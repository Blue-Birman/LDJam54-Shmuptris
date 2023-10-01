extends Area2D
class_name BaseTetromino

signal on_floor
var offset = Vector2(0, 0)
var grid_position = Vector2(0, 0)
var blocks_position = [Vector2.ZERO,Vector2.LEFT,Vector2.DOWN,Vector2.RIGHT]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass#



func move(move):
	position += move * 64
	position = position.round()
	position += Vector2.DOWN * 64
	position = position.round()
	var stop_move = false 





func _on_body_entered(body):
	on_floor.emit()
