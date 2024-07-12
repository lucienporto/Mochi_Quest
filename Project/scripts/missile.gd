extends CharacterBody2D

var move_speed: float = 200.0
var direction: int = 1

func _process(delta):
	position.x += move_speed * direction * delta

func set_direction(dir):
	direction = dir
	
	if dir < 0:
		$anim.flip_h = true
	else:
		$anim.flip_h = false
