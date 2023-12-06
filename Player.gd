extends CharacterBody2D


const SPEED = 400
const JUMP_VELOCITY = -400
const WALL_SLIDE_GRAVITY = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_wall_sliding = false

func game_over():
	position.x = 0

func set_wall_sliding():
		if is_on_wall():
			if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				is_wall_sliding = true
			else:
				is_wall_sliding = false
		else:
			is_wall_sliding = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_wall_sliding:
		velocity.y += (WALL_SLIDE_GRAVITY * delta)
		velocity.y = min(velocity.y, WALL_SLIDE_GRAVITY)
	
	if is_wall_sliding and Input.is_action_pressed("up"):
		velocity.y -= 25
	
	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
