extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		if body.has_method("_on_fall_collider_body_entered"):
			body._on_fall_collider_body_entered(body)
