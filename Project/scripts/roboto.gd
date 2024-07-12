extends CharacterBody2D

@onready var sprite = $Sprite
@onready var hurt_sprite = $Sprite/HurtSprite
@onready var anim = $Anim
@onready var player_detector = $PlayerDetector
@onready var shortcut = $Shortcut
@onready var spin = $Spin
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox = $Hitbox
@onready var wall_detector = $WallDetector

var move_speed: int = 50
var direction: int = 1
var health_points = 15

enum EnemyState {PATROL, PUNCH, HURT, SHORT}
var current_state = EnemyState.PATROL

func _physics_process(delta):
	match (current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.PUNCH : punch_state()

func patrol_state():
	anim.play("walking")
	move_speed = 50
	
	if is_on_wall():
		flip_enemy()
	
	if player_detector.is_colliding():
		_change_state(EnemyState.PUNCH)
	
	if wall_detector.is_colliding():
		flip_enemy()
	
	velocity.x = move_speed * direction
	move_and_slide()

func punch_state():
	anim.play("punch")
	spin.play(0.1)
	move_speed = 160
	
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROL)
	
	velocity.x = move_speed * direction
	move_and_slide()

func hurt_state():
	anim.play("hurt")
	hurt_sprite.visible = true
	await get_tree().create_timer(0.2).timeout
	hurt_sprite.visible = false
	_change_state(EnemyState.PATROL)
	
	if health_points > 0:
		health_points -= 1
	else:
		_change_state(EnemyState.SHORT)
		short_state()

func short_state():
	hitbox.queue_free()
	collision_shape_2d.queue_free()
	anim.play("shortcut")
	shortcut.play()
	await get_tree().create_timer(0.5).timeout
	Globals.score += 700
	queue_free()

func _change_state(state):
	current_state = state

func flip_enemy():
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	direction *= -1

func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()
