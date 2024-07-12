extends Node

@onready var message_box_scene = preload("res://misc/message_box.tscn")
var message_lines: Array[String] = []
var current_line = 0

var message_box
var message_box_position = Vector2.ZERO

var is_message_active: bool = false
var can_advance_message: bool = false

func start_message(position: Vector2, lines: Array[String]):
	if is_message_active:
		return
	
	message_lines = lines
	message_box_position = position
	show_text()
	is_message_active = true

func show_text():
	message_box = message_box_scene.instantiate()
	message_box.text_display_finished.connect(_on_all_text_displayed)
	get_tree().root.add_child(message_box)
	message_box.global_position = message_box_position
	message_box.display_text(message_lines[current_line])
	can_advance_message = false

func _on_all_text_displayed():
	can_advance_message = true

func _unhandled_input(event):
	if(event.is_action_pressed("advance_message") && is_message_active && can_advance_message):
		message_box.queue_free()
		current_line += 1
		if current_line >= message_lines.size():
			is_message_active = false
			current_line = 0
			return
		show_text()
