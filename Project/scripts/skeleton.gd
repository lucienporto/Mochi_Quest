extends CharacterBody2D

@onready var sprite = $Sprite
@onready var anim = $Anim
@onready var bone_spawn_point = $BoneSpawnPoint
@onready var ground_detector = $GroundDetector
@onready var player_detector = $PlayerDetector

const BONE = preload("res://misc/bone.tscn")

var move_speed: int = 20
var direction: int = 1
var health_point = 1

enum EnemyState {PATROL, SHOOT, HURT}
var current_state = EnemyState.PATROL

func _physics_process(delta):
	match (current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.SHOOT : shoot_state()

func patrol_state():
	anim.play("walking")
	
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
	await get_tree().create_timer(0.3).timeout
	_change_state(EnemyState.PATROL)
	if health_point > 0:
		health_point -= 1
	else:
		Globals.score += 225
		queue_free()

func spawn_bone():
	var new_bone = BONE.instantiate()
	if sign(bone_spawn_point.position.x) == 1:
		new_bone.set_direction(1)
	else:
		new_bone.set_direction(-1)
	add_sibling(new_bone)
	new_bone.global_position = bone_spawn_point.global_position

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	bone_spawn_point.position.x *= -1

func _change_state(state):
	current_state = state

func _on_hitbox_body_entered(body):
	_change_state(EnemyState.HURT)
	hurt_state()
