extends Control


func _on_title_pressed():
	get_tree().change_scene_to_file("res://ui_components/title.tscn")


func _on_quit_pressed():
	get_tree().quit()
