extends CharacterBody2D

@onready var sprite = $Sprite
@onready var anim = $anim
@onready var ground_detector = $GroundDetector
@onready var player_detector = $PlayerDetector

var move_speed: int = 50
var direction: int = 1
var health_point = 1

enum EnemyState {PATROL, ROLL, HURT}
var current_state = EnemyState.PATROL

func _physics_process(delta):
	match(current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.ROLL : roll_state()

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1

func _change_state(state):
	current_state = state

func patrol_state():
	anim.play("running")
	move_speed = 50
	
	if is_on_wall():
		flip_enemy()
	
	if not ground_detector.is_colliding():
		flip_enemy()
		
	if player_detector.is_colliding():
		_change_state(EnemyState.ROLL)
	
	velocity.x = move_speed * direction
	move_and_slide()

func roll_state():
	anim.play("rolling")
	
	move_speed = 120
	velocity.x = move_speed * direction
	move_and_slide()
	
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROL)

func hurt_state():
	anim.play("hurt")
	await get_tree().create_timer(0.2).timeout
	_change_state(EnemyState.PATROL)
	if health_point > 0:
		health_point -= 1
	else:
		Globals.score += 180
		queue_free()

func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()
