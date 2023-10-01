extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -1000.0

signal shoot(pos, direction)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_shoot = true

func _process(delta):
	var gun_direction = (get_global_mouse_position() - global_position).normalized()
	$Gun.position = gun_direction * 40
	$Gun.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("primary_action"): # and can_shoot:
		print("shooting")
		can_shoot = false
		var pos = $Gun/Marker2D.global_position
		var player_direction = (get_global_mouse_position() - position).normalized()
		$ShootTimer.start()
		shoot.emit(pos, player_direction)

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_shoot_timer_timeout():
	print("can shoot again")
	can_shoot = true
	
	
