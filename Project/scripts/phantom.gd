extends CharacterBody2D

@onready var anim = $Anim

func _on_hitbox_body_entered(body):
	if body.name == "Player":
		anim.play("hurt")
		await get_tree().create_timer(0.2).timeout
		queue_free()


func _on_area_2d_body_entered(body):
	if body.name == "Phantom":
		anim.flip_h = true


func _on_area_2d_2_body_entered(body):
	if body.name == "Phantom":
		anim.flip_h = false
