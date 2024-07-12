extends CharacterBody2D

@onready var sprites := $AnimatedSprite2D as AnimatedSprite2D

const SPEED = 200.0
const JUMP_FORCE = -300.0

# Gravidade configurada no project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping: bool = false


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
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprites.scale.x = direction
		if !is_jumping:
			sprites.play("walk")
		else:
			sprites.play("jump")
			is_jumping = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_jumping or velocity.y > 0:
			sprites.play("jump")
		else:
			sprites.play("idle")

	move_and_slide()
