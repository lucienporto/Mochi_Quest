extends Node2D

@onready var buy_heart_1 = $MarginContainer/VBoxContainer/HBoxContainer/ItemOne/Buy_Heart1
@onready var vending = $Vending
@onready var sprite_2d = $Sprite2D
@onready var area_2d = $Area2D
@onready var error_fx = $ErrorFx
@onready var buy_fx = $BuyFx

# Called when the node enters the scene tree for the first time.
func _ready():
	vending.visible = false

func _unhandled_input(event):
	if area_2d.get_overlapping_bodies().size() > 0:
		sprite_2d.show()
		if event.is_action_pressed("interact"):
			sprite_2d.hide()
			vending.visible = true
			get_tree().paused = true
	else:
		sprite_2d.hide()

func _on_buy_heart_1_pressed():
	if Globals.coins >= 20:
		Globals.player_health += 1
		Globals.coins -= 20
		buy_fx.play()
	else:
		error_fx.play()

func _on_buy_heart_2_pressed():
	if Globals.coins >= 45:
		Globals.player_health += 2
		Globals.coins -= 45
		buy_fx.play()
	else:
		error_fx.play()

func _on_buy_heart_3_pressed():
	if Globals.coins >= 60:
		Globals.player_health += 3
		Globals.coins -= 60
		buy_fx.play()
	else:
		error_fx.play()

func _on_buy_life_1_pressed():
	if Globals.coins >= 75:
		Globals.player_life += 1
		Globals.coins -= 75
		buy_fx.play()
	else:
		error_fx.play()

func _on_buy_life_2_pressed():
	if Globals.coins >= 99:
		Globals.player_life += 2
		Globals.coins -= 99
		buy_fx.play()
	else:
		error_fx.play()

func _on_quit_machine_pressed():
	get_tree().paused = false
	vending.visible = false
