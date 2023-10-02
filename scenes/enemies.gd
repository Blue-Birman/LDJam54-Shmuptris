extends CharacterBody2D


const SPEED = 300.0
const FLY_VELOCITY = -10.0

signal shoot(pos, direction)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_shoot = true
var can_fly = true
var change_moves = true

var rng = RandomNumberGenerator.new()

func _process(delta):
	var gun_direction = Vector2.DOWN
	$Gun.position = gun_direction * 40
	$Gun.look_at(get_position_delta())
	
	if can_shoot: # and can_shoot:
		print("shooting")
		can_shoot = false
		var pos = $Gun/Marker2D.global_position
		var enemy_direction = get_position_delta()
		$ShootTimer.start()
		shoot.emit(pos, enemy_direction)

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Fly.
	if can_fly:
		velocity.y = FLY_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if change_moves:
		var direction = rng.randf_range(1, -1)
		velocity.x = direction * SPEED
		change_moves = false
		$MoveTimer.start(rng.randf_range(0, 2))

	move_and_slide()


func _on_shoot_timer_timeout():
	print("can shoot again")
	can_shoot = true
	

func _on_move_timer_timeout():
	change_moves = true
