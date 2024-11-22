extends CanvasLayer

func _ready():
	self.hide()

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().quit()

func game_over():
	get_tree().paused = true
	self.show()
