extends Node

var coins: int = 0
var score: int = 0
var player_health: int = 3
var player_life: int = 3
var player = null
var current_checkpoint = null

func respawn_player():
	if current_checkpoint != null:
		player.global_position = current_checkpoint.global_position
