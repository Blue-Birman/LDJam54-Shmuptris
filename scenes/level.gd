extends Node2D

var tetromino
var next_tetromino
var bullet_scene = preload("res://scenes/bullet.tscn")
var i_block = preload("res://scenes/tetris_blocks/i_block.tscn")
var t_block = preload("res://scenes/tetris_blocks/t_block.tscn")
var o_block = preload("res://scenes/tetris_blocks/o_block.tscn")
var j_block = preload("res://scenes/tetris_blocks/j_block.tscn")
var l_block = preload("res://scenes/tetris_blocks/l_block.tscn")
var z_block = preload("res://scenes/tetris_blocks/z_block.tscn")
var s_block = preload("res://scenes/tetris_blocks/s_block.tscn")
var tetrominoes

signal endgame

func _ready():
	tetrominoes = [i_block, t_block, o_block, j_block, l_block, z_block, s_block]
	next_tetromino = tetrominoes[randi() % tetrominoes.size()]
	tetromino = tetrominoes[randi() % tetrominoes.size()].instantiate() as Node2D
	$Tetrominoes.add_child(tetromino)
	tetromino.connect("on_floor", _on_tetromino_on_floor)

func _process(delta):
	if Input.is_action_just_pressed("secondary_action"):
		tetromino.rotate_block($Blocks.get_children())

func _on_tetris_timer_timeout():
	var blocks = $Blocks.get_children()
	if ($Player.global_position.x - tetromino.global_position.x) > 64:
		tetromino.move(Vector2.RIGHT, blocks)
	elif ($Player.global_position.x - tetromino.global_position.x) < -64:
		tetromino.move(Vector2.LEFT, blocks)
	else:
		tetromino.move(Vector2.ZERO, blocks)


func _on_tetromino_on_floor():
	tetromino.disconnect("on_floor", _on_tetromino_on_floor)
	var blocks = tetromino.get_child(0).get_children()
	for block in blocks:
		block.position = block.global_position
		tetromino.get_child(0).remove_child(block)
		$Blocks.add_child(block)
		block.activate_collisions()
	tetromino.queue_free()
	tetromino = next_tetromino.instantiate() as Node2D
	$Tetrominoes.add_child(tetromino)
	tetromino.connect("on_floor", _on_tetromino_on_floor)
	next_tetromino = tetrominoes[randi() % tetrominoes.size()]
	for block in $Blocks.get_children():
		if block.grid_position.y < 0:
			get_tree().quit()


func _on_player_shoot(pos, direction):
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.position = pos
	bullet.rotation = direction.angle() + deg_to_rad(90)
	bullet.direction = direction
	$Projectiles.add_child(bullet)
	bullet.connect("bullet_hit", _on_bullet_hit)
	
	
	
func _on_bullet_hit(bullet, body):
	if body.get_parent() == $Blocks:
		body.hit()
	bullet.queue_free()
