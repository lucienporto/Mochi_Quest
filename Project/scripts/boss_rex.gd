extends CharacterBody2D

@onready var sprite = $Sprite
@onready var anim = $anim
@onready var fire_ball_spawn_point = $FireBallSpawnPoint
@onready var ground_detector = $GroundDetector
@onready var player_detector = $PlayerDetector
@onready var hurt_sprite = $Sprite/HurtSprite
@onready var cry = $Cry
@onready var firing = $Firing

const BIGFIREBALL: PackedScene = preload("res://misc/big_fire_ball.tscn")

var move_speed: int = 60
var direction: int = 1
var health_point = 20

enum EnemyState {PATROL, SHOOT, HURT}
var current_state = EnemyState.PATROL
@export var target: CharacterBody2D

func _physics_process(delta):
	match(current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.SHOOT : shoot_state()

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	fire_ball_spawn_point.position.x *= -1

func spawn_fireball():
	var new_fireball = BIGFIREBALL.instantiate()
	if sign(fire_ball_spawn_point.position.x) == 1:
		new_fireball.set_direction(1)
	else:
		new_fireball.set_direction(-1)
	add_sibling(new_fireball)
	firing.play()
	new_fireball.global_position = fire_ball_spawn_point.global_position
	await get_tree().create_timer(2.5).timeout
	new_fireball.queue_free()

func patrol_state():
	anim.play("running")
	if is_on_wall():
		flip_enemy()
	
	if not ground_detector.is_colliding():
		flip_enemy()
		
	if player_detector.is_colliding():
		_change_state(EnemyState.SHOOT)
	
	velocity.x = move_speed * direction
	move_and_slide()

func shoot_state():
	anim.play("shooting")
	
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROL)

func hurt_state():
	anim.play("hurt")
	hurt_sprite.visible = true
	await get_tree().create_timer(0.3).timeout
	hurt_sprite.visible = false
	_change_state(EnemyState.PATROL)
	if health_point > 0:
		health_point -= 1
	else:
		cry.play()
		await get_tree().create_timer(0.3).timeout
		Globals.score += 800
		queue_free()

func _change_state(state):
	current_state = state

func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()
