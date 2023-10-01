extends Node2D

var tetromino
var next_tetromino
var bullet_scene = preload("res://scenes/bullet.tscn")
var i_block = preload("res://scenes/tetris_blocks/i_block.tscn")
var t_block = preload("res://scenes/tetris_blocks/t_block.tscn")
var tetrominoes


func _ready():
	tetrominoes = [i_block, t_block]
	next_tetromino = tetrominoes[randi() % tetrominoes.size()]
	#tetromino = tetrominoes[randi() % tetrominoes.size()].instantiate() as Area2D
	tetromino = tetrominoes[0].instantiate() as Area2D
	$Tetrominoes.add_child(tetromino)
	print(tetromino)
	tetromino.connect("on_floor", _on_tetromino_on_floor)
	tetromino.position = Vector2(64*5, 0) + tetromino.offset

func _process(delta):
	pass

func _on_tetris_timer_timeout():
	print("player y")
	print($Player.global_position.x)
	print("tetromino Y")
	print(tetromino.global_position.x)
	if ($Player.global_position.x - tetromino.global_position.x) > 64:
		tetromino.move(Vector2.RIGHT)
	elif ($Player.global_position.x - tetromino.global_position.x) < -64:
		tetromino.move(Vector2.LEFT)
	else:
		tetromino.move(Vector2.ZERO)


func _on_tetromino_on_floor():
	tetromino.disconnect("on_floor", _on_tetromino_on_floor)
	var blocks = tetromino.get_child(1).get_children()
	for block in blocks:
		block.position = block.global_position
		tetromino.get_child(1).remove_child(block)
		$Blocks.add_child(block)
		block.activate_collisions()
	tetromino.queue_free()
	tetromino = next_tetromino.instantiate() as Area2D
	$Tetrominoes.add_child(tetromino)
	tetromino.position = Vector2(64*5, 0) + tetromino.offset
	tetromino.connect("on_floor", _on_tetromino_on_floor)
	next_tetromino = tetrominoes[randi() % tetrominoes.size()]


func _on_player_shoot(pos, direction):
	var bullet = bullet_scene.instantiate() as Area2D
	print(bullet)
	bullet.position = pos
	bullet.rotation = direction.angle() + deg_to_rad(90)
	bullet.direction = direction
	$Projectiles.add_child(bullet)
	bullet.connect("bullet_hit", _on_bullet_hit)
	
	
func _on_bullet_hit(bullet, body):
	if body.get_parent() == $Blocks:
		body.hit()
	bullet.queue_free()
