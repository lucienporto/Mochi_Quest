extends CharacterBody2D

@onready var sprite = $Sprite
@onready var hurt_sprite = $Sprite/HurtSprite
@onready var magic_spawn_point = $MagicSpawnPoint
@onready var sparkle_spawn_point = $SparkleSpawnPoint
@onready var player_detector = $PlayerDetector
@onready var wall_detector = $WallDetector
@onready var anim = $Anim
@onready var hitbox = $Hitbox
@onready var collision_shape_2d = $CollisionShape2D
@onready var sparkling = $Sparkling
@onready var spell_shoot = $SpellShoot

enum EnemyState {PATROL, SHOOT, HURT, DEFEATED}

const MAGICBALL = preload("res://misc/magic_ball.tscn")
const SPARKLETRAIL = preload("res://misc/sparkle_trail.tscn")
var move_speed: int = 60
var direction: int = 1
var health_points: int = 12
var current_state = EnemyState.PATROL

func _physics_process(delta):
	match (current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.SHOOT : shoot_state()

func patrol_state():
	anim.play("flying")
	
	if is_on_wall():
		flip_enemy()
	
	if player_detector.is_colliding():
		_change_state(EnemyState.SHOOT)
		
	if wall_detector.is_colliding():
		flip_enemy()
	
	
	velocity.x = move_speed * direction
	move_and_slide()

func shoot_state():
	anim.play("magic")
	
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROL)

func hurt_state():
	anim.play("hurt")
	hurt_sprite.visible = true
	await get_tree().create_timer(0.2).timeout
	hurt_sprite.visible = false
	_change_state(EnemyState.PATROL)
	
	if health_points > 0:
		health_points -= 1
	else:
		_change_state(EnemyState.DEFEATED)
		defeated_state()

func defeated_state():
	hitbox.queue_free()
	collision_shape_2d.queue_free()
	anim.play("defeated")
	await get_tree().create_timer(1.2).timeout
	anim.play("sparkledeath")
	sparkling.play()
	Globals.score += 600
	await get_tree().create_timer(0.4).timeout
	queue_free()

func _change_state(state):
	current_state = state

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	wall_detector.scale.x *= -1
	magic_spawn_point.position.x *= -1
	sparkle_spawn_point.position.x *= -1

func spawn_magic():
	var new_magicball = MAGICBALL.instantiate()
	var new_sparkletrail = SPARKLETRAIL.instantiate()
	if sign(magic_spawn_point.position.x) == 1 and sign(sparkle_spawn_point.position.x) == 1:
		new_magicball.set_direction(1)
		new_sparkletrail.set_direction(1)
	else:
		new_magicball.set_direction(-1)
		new_sparkletrail.set_direction(-1)
	add_sibling(new_magicball)
	spell_shoot.play()
	add_sibling(new_sparkletrail)
	await get_tree().create_timer(0.1).timeout
	add_sibling(new_sparkletrail)
	new_magicball.global_position = magic_spawn_point.global_position
	new_sparkletrail.global_position = sparkle_spawn_point.global_position

func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()
