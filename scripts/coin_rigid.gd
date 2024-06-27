extends RigidBody2D

func _on_coin_tree_exiting():
	queue_free()
