extends CharacterBody2D

@onready var sprite = $Sprite
@onready var anim = $anim
@onready var ground_detector = $GroundDetector
@onready var hurt_sprite = $Sprite/HurtSprite

var move_speed: int = 35
var direction: int = 1

func _physics_process(delta):
	if is_on_wall():
		flip_enemy()
	
	if not ground_detector.is_colliding():
		flip_enemy()
	
	velocity.x = move_speed * direction
	move_and_slide()

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1

func _on_hitbox_body_entered(body):
	await get_tree().create_timer(0.2).timeout
	queue_free()
	Globals.score += 125
