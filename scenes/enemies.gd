extends CharacterBody2D


const SPEED = 300.0
const FLY_VELOCITY = -100.0

signal shoot(pos)

var gravity = 30
var can_shoot = true
var can_fly = true
var change_moves = true

var rng = RandomNumberGenerator.new()

func _process(delta):	
	if can_shoot:
		can_shoot = false
		$ShootTimer.start()
		shoot.emit(global_position)

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Fly.
	if can_fly:
		velocity.y = FLY_VELOCITY
		can_fly = false
		$FlyTimer.start(rng.randi_range(3, 7))
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if change_moves:
		var direction = rng.randf_range(1, -1)
		velocity.x = direction * SPEED
		change_moves = false
		$MoveTimer.start(rng.randf_range(0, 2))

	move_and_slide()


func _on_shoot_timer_timeout():
	can_shoot = true
	

func _on_move_timer_timeout():
	change_moves = true


func _on_fly_timer_timeout():
	can_fly = true
