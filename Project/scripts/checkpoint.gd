extends Area2D

@onready var anim = $anim
@onready var marker_2d = $Marker2D
@onready var checking = $Checking

var is_active: bool = false


func _on_body_entered(body):
	if body.name != "Player" or is_active:
		return
	activate_checkpoint()

func activate_checkpoint():
	Globals.current_checkpoint = marker_2d
	anim.play("raising")
	checking.play()
	is_active = true

func _on_anim_animation_finished():
	if anim.animation == "raising":
		anim.play("checked")
