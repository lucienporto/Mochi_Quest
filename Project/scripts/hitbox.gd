extends Area2D

@onready var damage = $Damage

func _on_body_entered(body):
	if body.name == "Player":
		body.velocity.y = -body.jump_velocity
		damage.play()
		get_parent().anim.play("hurt")
