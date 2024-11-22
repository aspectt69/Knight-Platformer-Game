extends Control
class_name HUD

@onready var coin_label: Label = $CoinTexture/CoinLabel
@onready var score_label: Label = $ScoreLabel

# Updates coins and scores

func update_coins(coins: int):
	coin_label.text = "Coins: " + str(coins)

func update_score(score: int):
	score_label.text = "Score: " + str(score)
