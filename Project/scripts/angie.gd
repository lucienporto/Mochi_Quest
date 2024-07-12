extends CharacterBody2D

@onready var sprite = $Sprite
@onready var player_detector = $PlayerDetector
@onready var anim = $anim
@onready var seed_spawn_point = $SeedSpawnPoint

const SEED = preload("res://misc/seed.tscn")

enum EnemyState {IDLE, SHOOT, HURT}
var current_state = EnemyState.IDLE

func _physics_process(delta):
	match(current_state):
		EnemyState.IDLE : idle_state()
		EnemyState.SHOOT : shoot_state()

func idle_state():
	anim.play("idle")
	
	if player_detector.is_colliding():
		_change_state(EnemyState.SHOOT)

func shoot_state():
	anim.play("shoot")
	
	if not player_detector.is_colliding():
		_change_state(EnemyState.IDLE)

func hurt_state():
	anim.play("hurt")
	await get_tree().create_timer(0.2).timeout
	Globals.score += 120
	queue_free()

func spawn_seed():
	var new_seed = SEED.instantiate()
	if sign(seed_spawn_point.position.x) == 1:
		new_seed.set_direction(1)
	else:
		new_seed.set_direction(-1)
	add_sibling(new_seed)
	new_seed.global_position = seed_spawn_point.global_position

func _change_state(state):
	current_state = state

func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()
