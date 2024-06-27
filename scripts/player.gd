extends CharacterBody2D

@onready var sprites := $AnimatedSprite2D as AnimatedSprite2D
@onready var remote_transform: RemoteTransform2D = $RemoteTransform2D
@onready var ray_right: RayCast2D = $RayRight
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_down: RayCast2D = $RayDown
@onready var ray_up: RayCast2D = $RayUp

signal player_has_died()

const SPEED = 200.0
const JUMP_FORCE = -300.0

# Gravidade configurada no project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping: bool = false
var is_hurted: bool = false
var knockback_vector = Vector2.ZERO
var direction

func _physics_process(delta):
	# Adiciona gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Configurando pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
		

	# Movimentação
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
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
	if ray_right.is_colliding():
		take_damage(Vector2(-200, -200))
	elif ray_left.is_colliding():
		take_damage(Vector2(200, -200))

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
	
	if Globals.player_health <= 0:
		queue_free()
		Globals.player_life -= 1
		emit_signal("player_has_died")

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
			body.create_coin()
			if body.hitpoints == 0:
				body.break_sprites()

func _on_spike_collider_body_entered(body):
	if ray_down.is_colliding() or ray_left.is_colliding() or ray_right.is_colliding():
		take_damage(Vector2(-200, -200))
	elif ray_up.is_colliding():
		take_damage(Vector2(200, 200))
