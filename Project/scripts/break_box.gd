extends CharacterBody2D

const BOX_PIECES = preload("res://misc/box_pieces.tscn")
const COIN_INSTANCE = preload("res://items/coin_rigid.tscn")

@export var pieces: PackedStringArray
@export var hitpoints: int = 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spawn_coin: Marker2D = $SpawnCoin
@onready var hit_box: AudioStreamPlayer = $HitBox

var impulse: int = 100

func break_sprites():
	for piece in pieces.size():
		var piece_instance = BOX_PIECES.instantiate()
		get_parent().add_child(piece_instance)
		piece_instance.get_node("texture").texture = load(pieces[piece])
		piece_instance.global_position = global_position
		piece_instance.apply_impulse(Vector2(randi_range(-impulse, impulse), randi_range(-impulse, -impulse * 2)))
	queue_free()

func create_coin():
	var coin = COIN_INSTANCE.instantiate()
	get_parent().call_deferred("add_child", coin)
	coin.global_position = spawn_coin.global_position
	coin.apply_impulse(Vector2(randi_range(-50, 50), -150))
