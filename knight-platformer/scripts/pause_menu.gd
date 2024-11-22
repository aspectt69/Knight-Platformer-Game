extends CanvasLayer


func _ready():
	self.hide()

func pause_game():
	get_tree().paused = true
	self.show()

func _on_play_pressed():
	get_tree().paused = false
	self.hide()

func _on_exit_pressed():
	get_tree().quit()
