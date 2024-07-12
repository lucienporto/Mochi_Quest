extends Area2D

@onready var anim = $anim
@onready var holder = $Holder
@onready var boss_fight = $BossFight

var boss_defeated: bool = false

func _on_body_exited(body):
	if body.is_in_group("boss"):
		_open_gates(body)
	
	if body.name == "Player":
		boss_fight.stop()

func _open_gates(body):
	anim.play("open")
	boss_fight.stop()
	boss_defeated = true
	
func _on_body_entered(body):
	if body.name == "Player":
		if boss_defeated:
			return
		boss_fight.play()
		holder.queue_free()
