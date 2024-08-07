extends Area2D

var coins: int = 1
@onready var coin_sfx: AudioStreamPlayer = $CoinSfx

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	$AnimatedSprite2D.play("collect")
	coin_sfx.play()
	#Evita colisão dupla com as moedas
	await $CollisionShape2D.call_deferred("queue_free")
	Globals.coins += coins

func _on_animated_sprite_2d_animation_finished():
	queue_free()
