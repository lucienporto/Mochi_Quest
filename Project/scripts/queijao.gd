extends CharacterBody2D

@onready var sprite = $Sprite
@onready var anim = $anim
@onready var missile_spawn_point = $MissileSpawnPoint
@onready var player_detector = $PlayerDetector
@onready var hurt_sprite = $Sprite/HurtSprite
@onready var wall_detector = $WallDetector
@onready var hurted_sprite = $Sprite/HurtedSprite
@onready var hitbox = $Hitbox
@onready var explosion = $Explosion
@onready var collision_shape_2d = $CollisionShape2D
@onready var cloud = $Sprite/Cloud
@onready var defeat_sound = $DefeatSound
@onready var firing = $Firing


@export var target: CharacterBody2D

const BIGMISSILE: PackedScene = preload("res://misc/big_missile.tscn")

var move_speed: int = 60
var direction: int = -1
var health_point = 8

enum EnemyState {PATROL, SHOOT, HURT, EXPLODE}
var current_state = EnemyState.PATROL

func _physics_process(delta):
	match(current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.SHOOT : shoot_state()

func patrol_state():
	anim.play("moving")
	if is_on_wall():
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
	hurted_sprite.visible = true
	await get_tree().create_timer(0.3).timeout
	hurted_sprite.visible = false
	_change_state(EnemyState.PATROL)
	if health_point > 0:
		health_point -= 1
	else:
		_change_state(EnemyState.EXPLODE)
		Globals.score += 500
		explode_state()

func explode_state():
	hitbox.queue_free()
	collision_shape_2d.queue_free()
	explosion.visible = true
	hurted_sprite.visible = true
	anim.play("explode")
	await get_tree().create_timer(1.7).timeout
	queue_free()

func _change_state(state):
	current_state = state

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	wall_detector.scale.x *= -1
	missile_spawn_point.position.x *= -1
	hitbox.scale.x *= -1
	cloud.position.x *= -1

func spawn_missile():
	var new_missile = BIGMISSILE.instantiate()
	if sign(missile_spawn_point.position.x) == 1:
		new_missile.set_direction(1)
		new_missile.scale.x = -1
	else:
		new_missile.set_direction(-1)
		new_missile.scale.x = -1
	
	add_sibling(new_missile)
	firing.play()
	new_missile.global_position = missile_spawn_point.global_position
	#await get_tree().create_timer(2.5).timeout
	#new_missile.queue_free()

func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()

func defeated():
	defeat_sound.play()
