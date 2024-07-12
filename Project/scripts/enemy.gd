class_name EnemyBase
extends CharacterBody2D

@onready var anim := $anim

@export var score_points: int = 100
@export var life_points: int = 2

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wall_detector
var spike_detector
var sprite
var direction: int = -1
var can_spawn: bool = false
var spawn_instance: PackedScene = null
var spawn_instance_position

func apply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

func movement(delta):
	velocity.x = direction * SPEED * delta
	
	move_and_slide()

func flip_direction():
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		sprite.scale.x *= -1

func kill_ground_enemy(anim_name: StringName) -> void:
	kill_and_score()

func kill_air_enemy():
	kill_and_score()

func killed_by_spike():
	if spike_detector.is_colliding():
		kill_and_score()

func kill_and_score():
	Globals.score += score_points
	
	if can_spawn:
		spawn_new_enemy()
		get_parent().queue_free()
	else:
		queue_free()

func spawn_new_enemy():
	var instance_scene = spawn_instance.instantiate()
	get_tree().root.add_child(instance_scene)
	instance_scene.global_position = spawn_instance_position.global_position

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hurt":
		Globals.score += score_points
		queue_free()
