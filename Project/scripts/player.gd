extends CharacterBody2D

@onready var sprites := $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_transform: RemoteTransform2D = $RemoteTransform2D
@onready var ray_down: RayCast2D = $RayDown
@onready var spike_collider = $spike_coll
@onready var jump_fx: AudioStreamPlayer = $JumpFx
@onready var destroy_fx = preload("res://misc/destroy_fx.tscn")
@onready var taking_damage = $TakingDamage
@onready var ray_down_2 = $RayDown2
@onready var ray_down_3 = $RayDown3

@export var jump_height:int = 64
@export var max_time_to_peak = 0.5

signal player_has_died()

const SPEED = 200.0
const AIR_FRICTION = 0.5

var jump_velocity
var gravity 
var fall_gravity
var is_jumping: bool = false
var is_hurted: bool = false
var knockback_vector = Vector2.ZERO
var knockback_power = 20
var direction

func _ready():
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	# Adiciona gravidade
	if not is_on_floor():
		#velocity.y += gravity * delta
		velocity.x = 0
	
	# Configurando pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_velocity
		is_jumping = true
		jump_fx.play()
	elif is_on_floor():
		is_jumping = false
	
	if velocity.y > 0 or not Input.is_action_pressed("jump"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
	
	# Movimentação
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		sprites.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

func _on_hurtbox_body_entered(body):
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	take_damage(knockback)
	taking_damage.play()
	
	if body.is_in_group("fireball"):
		body.queue_free()
	
	if body.is_in_group("missile"):
		body.queue_free()
	
	if body.is_in_group("seed"):
		body.queue_free()
	
	if body.is_in_group("magic"):
		body.queue_free()
	
	if body.is_in_group("bone"):
		body.queue_free()
	
	if Globals.player_health < 0:
		Globals.player_health = 0
		if Globals.player_life > 0:
			await get_tree().create_timer(0.3).timeout
			queue_free()
			Globals.player_life -= 1
			emit_signal("player_has_died")
		else:
			get_tree().change_scene_to_file("res://ui_components/game_over.tscn")

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force = Vector2.ZERO, duration: float = 0.25):
	Globals.player_health -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		var knockback_tween = get_tree().create_tween()
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		sprites.modulate = Color("Red")
		knockback_tween.parallel().tween_property(sprites, "modulate", Color(1,1,1,1), duration)
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false

func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "walk"
	
	if is_hurted:
		state = "hit"
	
	if sprites.name != state:
		sprites.play(state)

func _on_head_collider_body_entered(body):
	if body.has_method("break_sprites"):
		body.hitpoints -= 1
		if body.hitpoints >= 0:
			body.animation_player.play("hit")
			body.hit_box.play(0.1)
			body.create_coin()
		else:
			body.break_sprites()
			play_destroy_fx()

func _on_spike_collider_body_entered(body):
	var knockback = Vector2((global_position.x - body.global_position.x) / knockback_power, -200)
	if ray_down.is_colliding() or ray_down_2.is_colliding() or ray_down_3.is_colliding():
		taking_damage.play()
		take_damage(knockback)
	
	if Globals.player_health < 0:
		Globals.player_health = 0
		if Globals.player_life > 0:
			await get_tree().create_timer(0.3).timeout
			queue_free()
			Globals.player_life -= 1
			emit_signal("player_has_died")
		else:
			get_tree().change_scene_to_file("res://ui_components/game_over.tscn")

func _on_fall_collider_body_entered(body):
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -50)
	take_damage(knockback)
	Globals.player_health = 0
	
	if Globals.player_health == 0:
		if Globals.player_life > 0:
			await get_tree().create_timer(0.3).timeout
			queue_free()
			Globals.player_life -= 1
			emit_signal("player_has_died")
		else:
			get_tree().change_scene_to_file("res://ui_components/game_over.tscn")
	
	#if Globals.player_health < 0:
		#Globals.player_health = 0
		#if Globals.player_life > 0:
			#await get_tree().create_timer(0.3).timeout
			#queue_free()
			#Globals.player_life -= 1
			#emit_signal("player_has_died")
		#else:
			#get_tree().change_scene_to_file("res://ui_components/game_over.tscn")

func play_destroy_fx():
	var sound_fx = destroy_fx.instantiate()
	get_parent().add_child(sound_fx)
	sound_fx.play()
	await get_tree().create_timer(0.3).timeout
	sound_fx.queue_free()
