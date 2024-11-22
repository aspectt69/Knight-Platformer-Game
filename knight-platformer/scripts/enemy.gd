extends Node2D

const SPEED = 40
var direction = 1
var health = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var game_manager: Node = %GameManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# If the enemy hits terrain it will start moving the other way
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	elif ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	else:
		pass
	position.x += direction * SPEED * delta

func be_bounced_on(bouncer):
	# Checks if the player bounces on the enemy and kills it
	if bouncer.has_method("bounce"):
		bouncer.bounce()
		animated_sprite.play("death")
		timer.start()
		game_manager.add_score(5)
		game_manager.add_kill()
		print("Hit enemy head")

func _on_timer_timeout():
	# Removes enemy after death animation
	queue_free()
