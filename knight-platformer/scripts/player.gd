extends CharacterBody2D

# Constants
const SPEED = 90.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 135.0
const BOUNCE_VELOCITY = -250

# Variables
var player_dead = false
var player_rolling = false
var can_move = true
var can_jump = true
var last_direction_facing = 1
var hp = 3

# Loading variables
@onready var player_animation = $PlayerAnimation
@onready var roll_cooldown_timer: Timer = $RollCooldownTimer
@onready var bounce_raycasts = $BounceRaycasts
@onready var death_timer: Timer = $DeathTimer
@onready var health_bar: ProgressBar = $PlayerAnimation/HealthBar

func _ready():
	health_bar.value = hp

func player_damaged():
	# Kills the player if they have 0 hp, otherwise knocks them back
	hp -= 1
	if hp == 0:
		player_died()
	else:
		can_move = false
		player_animation.play("damage")
		knockback(-100, -75)
		print("Successful")
		
		
func player_died():
	# Disables all movement and starts a timer
	can_move = false
	can_jump = false
	player_dead = true
	player_animation.play("death")
	print("You died :(")
	Engine.time_scale = 0.5
	death_timer.start()

func kill_enemy():
	velocity.y = JUMP_VELOCITY
	print("Killed enemy")

func _physics_process(delta: float) -> void:
	health_bar.value = hp
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not player_rolling and can_jump:
		velocity.y = JUMP_VELOCITY
	
	# Pause menu
	if Input.is_action_just_pressed("pause"):
		get_node("../PauseMenu").pause_game()

	# Get input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		player_animation.flip_h = false
		last_direction_facing = 1
	elif direction < 0:
		player_animation.flip_h = true
		last_direction_facing = -1
		
	# Lets the player roll in the direction they're facing if they're alive
	if Input.is_action_just_pressed("roll") and not player_dead and not player_rolling:
		player_rolling = true
		can_move = false
		player_animation.play("roll")
		if direction != 0:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = last_direction_facing * DASH_SPEED
		roll_cooldown_timer.start()
		print("Started rolling | Direction: " + str(direction))
		
	if player_rolling:
		pass
	else:
		# Play Animations
		if is_on_floor() and not player_dead and can_move:
			if direction == 0:
				player_animation.play("idle")
			else:
				player_animation.play("run")
		if not is_on_floor() and not player_dead and can_move:
			player_animation.play("jump")
	
	# Apply Movement
	if not player_dead and can_move:
		if direction: 
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		pass
	
	_check_bounce(delta)
	move_and_slide()

func _on_roll_cooldown_timer_timeout():
	# Enables movement after roll is finished
	player_rolling = false
	can_move = true
	velocity.x = 0
	print("Roll timer done")
	
func _on_death_timer_timeout():
	# Shows game over after death
	Engine.time_scale = 1
	get_node("../GameOver").game_over()

func _check_bounce(delta):
	if velocity.y > 0:
		for raycast in bounce_raycasts.get_children():
			# Checks if the raycasts below the player are colliding with an enemy
			raycast.target_position = Vector2.DOWN * velocity * delta + Vector2.DOWN
			raycast.force_raycast_update()
			# This will push the player down onto the surface to make sure its a consistent jump every time
			if raycast.is_colliding():
				print("Detected bounce collision")
				velocity.y = (raycast.get_collision_point() - raycast.global_position - Vector2.DOWN).y / delta
				# Wait for next process to be called, because we cant hit the surface and bounce in the same frame
				# move_and_slide needs to be called first
				raycast.get_collider().entity.call_deferred("be_bounced_on", self)
				break

# Bounce off orbs and enemies
func bounce(bounce_velocity = BOUNCE_VELOCITY):
	velocity.y = bounce_velocity

# Get knocked back from enemies
func knockback(knockback_velocity: int, bounce_velocity = BOUNCE_VELOCITY):
	velocity.x = knockback_velocity
	velocity.y = bounce_velocity

# Enables movement after hit animation is finished
func _on_animation_finished():
	can_move = true
