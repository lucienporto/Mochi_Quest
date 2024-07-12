extends EnemyBase

@onready var spawn_enemy = $"../SpawnEnemy"

func _ready():
	anim.animation_finished.connect(kill_air_enemy)
	spawn_instance = preload("res://enemies/common/cherry.tscn")
	spawn_instance_position = spawn_enemy
	can_spawn = true
