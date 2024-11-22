extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D):
	# If player touches a coin updates the coin and score label
	if "Player" in body.name:
		game_manager.add_coin()
		game_manager.add_score(1)
		queue_free()
