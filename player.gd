extends CharacterBody2D

const SPEED = 100.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_punching := false
var is_kicking := false
var punch_idle_started := false  # New variable to control punch idle state
var kick_idle_started := false   # New variable to control kick idle state

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		animation.play("jump")
		is_jumping = true

	# Handle Punch.
	if Input.is_action_just_pressed("ui_attack") and velocity.x == 0:
		animation.play("combo")
		is_punching = true
		punch_idle_started = true  # Set the punch_idle_started state to true

	# Handle Kick.
	if Input.is_action_just_pressed("ui_kick") and velocity.x == 0:
		animation.play("kick")
		is_kicking = true
		kick_idle_started = true  # Set the kick_idle_started state to true

	# Handle Punch (Pressing "f").
	if Input.is_action_just_pressed("ui_punch") and velocity.x == 0:
		animation.play("punch")
		is_punching = true
		punch_idle_started = true  # Set the punch_idle_started state to true

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if !is_jumping:
			animation.play("walk")
		elif is_jumping:
			animation.play("jump")

		# Flip the sprite based on the movement direction.
		animation.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Check if no animation is being played and the player is not moving, except when kicking.
	if !animation.is_playing() and velocity.x == 0 and !is_kicking:
		if punch_idle_started:
			punch_idle_started = false
			animation.play("idle")
		elif kick_idle_started:
			kick_idle_started = false
			animation.play("idle")
		else:
			animation.play("idle")

	# Check if the punch animation finished, then stop punching.
	if is_punching and !animation.is_playing():
		is_punching = false

	# Check if the kick animation finished, then stop kicking.
	if is_kicking and !animation.is_playing():
		is_kicking = false

	move_and_slide()

func _on_AnimatedSprite2D_animation_finished():
	is_punching = false
