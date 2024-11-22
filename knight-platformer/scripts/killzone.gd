extends Area2D


func _on_body_entered(body: Node2D):
	# If player touches kill zone (enemy), they will take damage
	# Otherwise if they fell off, they will die
	if body is CharacterBody2D:
		var player = body as CharacterBody2D
		if is_in_group("enemy_killzones"):
			print("Damage taken from enemy")
			player.player_damaged()
		else:
			print("Player fell off")
			player.player_died()
