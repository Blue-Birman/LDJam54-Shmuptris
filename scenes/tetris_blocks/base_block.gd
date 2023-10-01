extends StaticBody2D

var health = 4

var bullet_health_4 = preload("res://assets/images/BaseBlock.png")
var bullet_health_3 = preload("res://assets/images/CrackedBlock1.png")
var bullet_health_2 = preload("res://assets/images/CrackedBlock2.png")
var bullet_health_1 = preload("res://assets/images/CrackedBlock3.png")

var grid_position = Vector2(0,0)

func activate_collisions():
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(6, true)
	

func hit():
	health -= 1
	match health:
		4:
			$Sprite2D.texture = bullet_health_4
		3:
			$Sprite2D.texture = bullet_health_3
		2:
			$Sprite2D.texture = bullet_health_2
		1:
			$Sprite2D.texture = bullet_health_1
	if health == 0:
		queue_free()

	

