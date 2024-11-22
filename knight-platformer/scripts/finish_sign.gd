extends Area2D


func _on_body_entered(body: Node2D):
	if "Player" in body.name:
		print("Player touched finish")
		get_node("../Finished").level_finish()
