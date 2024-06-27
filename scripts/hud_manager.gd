extends Control

@onready var coins_count: Label = $MarginContainer/StatusContainer/CoinsContainer/CoinsCount
@onready var score_count: Label = $MarginContainer/StatusContainer/ScoreContainer/ScoreCount
@onready var life_count: Label = $MarginContainer/LifeContainer/LifeCount
@onready var health_count = $MarginContainer/StatusContainer/HealthContainer/HealthCount
# Called when the node enters the scene tree for the first time.
func _ready():
	coins_count.text = str("%04d" % Globals.coins)
	score_count.text = str("%06d" % Globals.score)
	life_count.text = str("%02d" % Globals.player_life)
	health_count.text = str("%02d" % Globals.player_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coins_count.text = str("%04d" % Globals.coins)
	score_count.text = str("%06d" % Globals.score)
	life_count.text = str("%02d" % Globals.player_life)
	health_count.text = str("%02d" % Globals.player_health)
