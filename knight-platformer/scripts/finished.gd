extends CanvasLayer

@onready var final_score_label: Label = $FinalScoreLabel
@onready var final_coins_label: Label = $FinalCoinsLabel
@onready var final_kills_label: Label = $FinalKillsLabel
@onready var game_manager: Node = %GameManager
@onready var coins: Node = $"../Coins"
@onready var slimes: Node = $"../Enemies/Slimes"

var total_coins = 0
var total_enemies = 0
var enemy_kills = 0
var max_score = 0

func _ready():
	self.hide()
	# Get total coins and enemies from their nodes
	total_coins = coins.get_child_count()
	total_enemies = slimes.get_child_count()
	print("Total coins: " + str(total_coins))
	print("Total enemies:" + str(total_enemies))

func level_finish():
	var final_score = game_manager.score
	var final_coins = game_manager.coins
	var enemy_kills = game_manager.enemy_kills
	var coin_percentage = round(float(final_coins) / float(total_coins) * 100)
	var kill_percentage = round(float(enemy_kills) / float(total_enemies) * 100)
	
	# Calculate max possible score
	max_score = total_enemies * 5 + total_coins
	
	# Update all the labels
	final_score_label.text = "Score: " + str(final_score) + "/" + str(max_score)
	final_coins_label.text = "Coins: " + str(final_coins) + "/" + str(total_coins) + " - " + str(coin_percentage) + "%"
	final_kills_label.text = "Kills: " + str(enemy_kills) + "/" + str(total_enemies) + " - " + str(kill_percentage) + "%"
	
	get_tree().paused = true
	self.show()

func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().quit()
