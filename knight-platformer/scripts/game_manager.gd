extends Node

# This script just updates some labels

var coins = 0
var score = 0
var enemy_kills = 0
var hud : HUD

func _ready():
	hud = get_tree().get_first_node_in_group("hud")

func add_coin():
	coins += 1
	hud.update_coins(coins)

func add_score(amount: int):
	score += amount
	hud.update_score(score)

func add_kill():
	enemy_kills += 1
