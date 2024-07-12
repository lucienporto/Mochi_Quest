extends CharacterBody2D

@onready var sprite = $Sprite
@onready var anim = $Anim
@onready var ground_detector = $GroundDetector
@onready var sit_detector = $SitDetector
@onready var player_detector = $PlayerDetector
@onready var dance_detector = $DanceDetector
@onready var duck_detector = $DuckDetector

var move_speed: int = 35
var direction: int = 1

enum EnemyState {PATROL, SIT, SLIDE, DANCE, DUCK, HURT}
var current_state = EnemyState.PATROL

func _physics_process(delta):
	match(current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.SIT : sit_state()
		EnemyState.SLIDE : slide_state()
		EnemyState.DANCE : dance_state()
		EnemyState.DUCK : duck_state()

func patrol_state():
	anim.play("walking")
	move_speed = 35
	
	if is_on_wall():
		flip_enemy()
	
	if not ground_detector.is_colliding():
		flip_enemy()
	
	if sit_detector.is_colliding():
		_change_state(EnemyState.SIT)
	
	if player_detector.is_colliding():
		_change_state(EnemyState.SLIDE)
	
	if dance_detector.is_colliding():
		_change_state(EnemyState.DANCE)
	
	if duck_detector.is_colliding():
		_change_state(EnemyState.DUCK)
	
	velocity.x = move_speed * direction
	move_and_slide()

func hurt_state():
	anim.play("hurt")
	await get_tree().create_timer(0.2).timeout
	Globals.score += 140
	queue_free()

func sit_state():
	anim.play("sitting")
	
	if not sit_detector.is_colliding():
		_change_state(EnemyState.PATROL)

func slide_state():
	anim.play("sliding")
	move_speed = 120
	
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROL)
	
	velocity.x = move_speed * direction
	move_and_slide()

func dance_state():
	anim.play("dancing")
	
	if not dance_detector.is_colliding():
		_change_state(EnemyState.PATROL)

func duck_state():
	anim.play("ducking")
	
	if not duck_detector.is_colliding():
		_change_state(EnemyState.PATROL)

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	sit_detector.scale.x *= -1
	player_detector.scale.x *= -1
	dance_detector.scale.x *= -1
	duck_detector.scale.x *= -1

func _change_state(state):
	current_state = state

func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()
