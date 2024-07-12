extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var area_2d = $Area2D

const MACHINE = preload("res://scripts/vending_machine.gd")

func _unhandled_input(event):
	if area_2d.get_overlapping_bodies().size() > 0:
		sprite_2d.show()
		if event.is_action_pressed("interact"):
			sprite_2d.hide()
			
	else:
		sprite_2d.hide()
		if MessageManager.message_box != null:
			MessageManager.message_box.queue_free()
			MessageManager.is_message_active = false
