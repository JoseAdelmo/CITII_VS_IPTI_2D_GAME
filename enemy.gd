extends CharacterBody2D

const SPEED = 2200.0
const LEFT_DURATION = 4.0
const RIGHT_DURATION = 4.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var wall_detector := $wall_detector as RayCast2D
var direction := -1
var timer := 0.0
var current_duration := LEFT_DURATION

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Make sure to set this variable to the correct node in your scene.
@onready var animated_sprite := $anim

var current_animation = "idle"  # Variable to track the current animation state

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Update the timer.
	timer += delta

	# Check for duration and change direction accordingly.
	if timer >= current_duration:
		direction *= -1
		timer = 0.0

		# Update the current duration.
		if current_duration == LEFT_DURATION:
			current_duration = RIGHT_DURATION
		else:
			current_duration = LEFT_DURATION

	# Move horizontally.
	velocity.x = direction * SPEED * delta

	move_and_slide()

	# Update the animation state.
	if direction != 0:
		current_animation = "walk"
	else:
		current_animation = "idle"

	# Flip the sprite based on the movement direction.
	# If moving to the left (direction < 0), flip the sprite horizontally.
	# If moving to the right (direction > 0), reset the sprite to its original orientation.
	animated_sprite.flip_h = direction < 0

	# Play the current animation.
	animated_sprite.play(current_animation)
	
