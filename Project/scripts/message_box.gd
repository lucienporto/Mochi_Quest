extends MarginContainer

@onready var text_label = $LabelMargin/TextLabel
@onready var timer = $Timer

const MAX_WIDTH: int = 256

var text = ""
var letter_index = 0

var letter_display_timer = 0.07
var space_display_timer = 0.05
var punctuaction_display_timer = 0.2

signal text_display_finished()

func display_text(text_to_display: String):
	text = text_to_display
	text_label.text = text_to_display
	
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	text_label.text = ""
	display_letter()

func display_letter():
	text_label.text += text[letter_index]
	letter_index += 1
	
	if letter_index >= text.length():
		text_display_finished.emit()
		return
	
	match text[letter_index]:
		"!", "?", ",", ".":
			timer.start(punctuaction_display_timer)
		" ":
			timer.start(space_display_timer)
		_:
			timer.start(letter_display_timer)

func _on_timer_timeout():
	display_letter()
