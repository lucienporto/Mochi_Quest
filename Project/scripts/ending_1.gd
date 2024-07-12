extends Node2D


func _on_animation_player_animation_finished(anim_name):
	anim_name = "find"
	get_tree().change_scene_to_file("res://ui_components/ending.tscn")
