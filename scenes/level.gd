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
var enemy_scene = preload("res://scenes/enemy.tscn")
var tetrominoes

var spawn_points = []
var rng = RandomNumberGenerator.new()

var score = 0
var hp = 50
var score_board = """Score: {score}
HP: {hp}
How to Play
Left Mouse - Shoot
Right Mouse - Rotate
Move - WASD/Up Down Left Right
Jump W / Up"""

signal endgame

func _ready():
	tetrominoes = [i_block, t_block, o_block, j_block, l_block, z_block, s_block]
	spawn_points = $SpawnLocation.get_children()
	next_tetromino = tetrominoes[randi() % tetrominoes.size()]
	tetromino = tetrominoes[randi() % tetrominoes.size()].instantiate() as Node2D
	$Tetrominoes.add_child(tetromino)
	tetromino.connect("on_floor", _on_tetromino_on_floor)
	for block in $Blocks.get_children():
		block.render_hp()
		block.activate_collisions()

func _process(delta):
	if Input.is_action_just_pressed("secondary_action"):
		tetromino.rotate_block($Blocks.get_children())
	$"UI/RichTextLabel".text = score_board.format({"score": score, "hp": hp})

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
		block.render_hp()
		block.connect("block_destroyed", _on_block_destroyed)
		if block.grid_position.y < 0:
			get_tree().quit()


func _on_player_shoot(pos, direction):
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.position = pos
	bullet.rotation = direction.angle() + deg_to_rad(90)
	bullet.direction = direction
	bullet.set_collision_mask_value(1, false)
	$Projectiles.add_child(bullet)
	bullet.connect("bullet_hit", _on_bullet_hit)
	
	
	
func _on_bullet_hit(bullet, body):
	if body.get_parent() == $Blocks:
		body.hit()
	elif body.get_parent() == $Enemies: 
		score += 5
		body.queue_free()
	elif body == $Player && bullet.get_collision_mask_value(1):
		hp -= 1
		if hp == 0:
			get_tree().quit()
	bullet.queue_free()
	
	
func _on_block_destroyed():
	score += 1


func _on_spawn_timer_timeout():
	var spawn_point = spawn_points[randi() % spawn_points.size()].global_position
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_point
	enemy.get_child(1).modulate = Color(
		rng.randf_range(0.5, 1.0),
		rng.randf_range(0.5, 1.0),
		rng.randf_range(0.5, 1.0)
	)
	enemy.connect("shoot", _on_enemy_shoot)
	$Enemies.add_child(enemy)

func _on_enemy_shoot(position):
	var player_position = $Player.global_position
	
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.global_position = position
	bullet.direction = (player_position - position).normalized()
	bullet.set_collision_mask_value(2, false)
	$Projectiles.add_child(bullet)
	bullet.connect("bullet_hit", _on_bullet_hit)
