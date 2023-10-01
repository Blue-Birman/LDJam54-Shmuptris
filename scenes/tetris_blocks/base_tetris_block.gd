extends Node2D
class_name BaseTetromino

signal on_floor
var offset = Vector2(5, 0)
var grid_size = 64
var grid_position = Vector2(4, 0)
var blocks_start_position = [Vector2.ZERO,Vector2.LEFT,Vector2.DOWN,Vector2.RIGHT]
var block_tint = Color(1, 1, 1)

const left_limit = 0
const right_limit = 8
const bottom_limit = 19
const init_center_position = Vector2(4,0)

func _on_ready():
	position = Vector2(96 + (4 * 64),32)
	for i in range(len(blocks_start_position)):
		$Blocks.get_child(i).grid_position = blocks_start_position[i] + init_center_position
		$Blocks.get_child(i).position = blocks_start_position[i] * 64
	for child in $Blocks.get_children():
		child.get_child(1).modulate = block_tint

func move(move, blocks):
	if move == Vector2.LEFT and can_move_left(blocks):
		move_block(Vector2.LEFT)
	elif move == Vector2.RIGHT and can_move_right(blocks):
		move_block(Vector2.RIGHT)
	
	if can_move_down(blocks):
		move_block(Vector2.DOWN)
	else:
		on_floor.emit()

func can_move_left(blocks):
	var left_most_index = right_limit
	var new_block_position = []
	for block in $Blocks.get_children():
		var block_position = block.grid_position
		block_position.x -= 1
		if block_position.x < left_most_index:
			left_most_index = block_position.x
			if left_most_index < left_limit:
				return false
			new_block_position = []
			new_block_position.append(block_position)
		else:
			new_block_position.append(block_position)
	for block in blocks:
		if block.grid_position in new_block_position:
			return false
	return true

func can_move_right(blocks):
	var right_most_index = left_limit
	var new_block_position = []
	for block in $Blocks.get_children():
		var block_position = block.grid_position
		block_position.x += 1
		if block_position.x > right_most_index:
			right_most_index = block_position.x
			if right_most_index > right_limit:
				return false
			new_block_position = []
			new_block_position.append(block_position)
		else:
			new_block_position.append(block_position)
	for block in blocks:
		if block.grid_position in new_block_position:
			return false
	return true

func can_move_down(blocks):
	var bottom_most_index = 0
	var new_block_position = []
	for block in $Blocks.get_children():
		var block_position = block.grid_position
		block_position.y += 1
		if block_position.y > bottom_most_index:
			bottom_most_index = block_position.y
			if bottom_most_index > bottom_limit:
				return false
			new_block_position = []
			new_block_position.append(block_position)
		else:
			new_block_position.append(block_position)
	for block in blocks:
		if block.grid_position in new_block_position:
			return false
	return true

func move_block(direction: Vector2):
	for block in $Blocks.get_children():
		block.grid_position += direction
	position += direction * 64

func rotate_block(blocks):
	var new_position = []
	for i in range (len(blocks_start_position)):
		new_position.append($Blocks.get_child(i).grid_position - blocks_start_position[i] + Vector2(blocks_start_position[i].y, -blocks_start_position[i].x))
	for block in blocks:
		if block.grid_position in new_position:
			return
	
	var kickback = Vector2.ZERO
	for i in range (len(new_position)):
		if kickback.x < -(new_position[i].x - left_limit):
			kickback.x = -(new_position[i].x - left_limit)
		elif kickback.x > right_limit - new_position[i].x:
			kickback.x = right_limit - new_position[i].x  
		
		if kickback.y > bottom_limit - new_position[i].y:
			kickback.y = -(new_position[i].y - bottom_limit)
	
	for i in range (len(new_position)):
		new_position[i] += kickback
	
	for block in blocks:
		if block.grid_position in new_position:
			return
	
	for i in range (len(new_position)):
		blocks_start_position[i] = new_position[i] - ($Blocks.get_child(i).grid_position - blocks_start_position[i])
		$Blocks.get_child(i).grid_position = new_position[i]
		$Blocks.get_child(i).position = 64 * blocks_start_position[i]
	


