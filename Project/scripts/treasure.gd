extends Area2D

@export var gold: int = 5
@onready var coin_sfx: AudioStreamPlayer = $CoinSfx

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	$AnimatedSprite2D.play("open")
	coin_sfx.play()
	await get_tree().create_timer(0.1).timeout
	coin_sfx.play()
	await get_tree().create_timer(0.1).timeout
	coin_sfx.play()
	await get_tree().create_timer(0.1).timeout
	#Evita colisão dupla com as moedas
	await $CollisionShape2D.call_deferred("queue_free")
	Globals.coins += gold


func _on_animated_sprite_2d_animation_finished():
	queue_free()
