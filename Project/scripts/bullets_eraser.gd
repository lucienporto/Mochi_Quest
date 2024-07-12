extends Area2D

@onready var anim = $anim

func _on_body_entered(body):
	if body.is_in_group("fireball"):
		body.queue_free()
		anim.global_position = body.global_position
		anim.play("explosion")
	
	if body.is_in_group("missile"):
		body.queue_free()
		anim.global_position = body.global_position
		anim.play("explosion")
	
	if body.is_in_group("seed"):
		body.queue_free()
		anim.global_position = body.global_position
		anim.play("seed_explode")
	
	if body.is_in_group("magic"):
		body.queue_free()
		anim.global_position = body.global_position
		anim.play("explosion")
	
	if body.is_in_group("bone"):
		body.queue_free()
		anim.global_position = body.global_position
		anim.play("poof")
