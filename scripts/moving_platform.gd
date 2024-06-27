extends Node2D

const WAIT_DURATION: float = 1.0

@export var move_speed: float = 3.0
@export var distance: int = 192
@export var move_horizontal: bool = true

@onready var platform: AnimatableBody2D = $Platform

var follow := Vector2.ZERO
var platform_center: int = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	moving_platform()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	platform.position = platform.position.lerp(follow, 0.5)

func moving_platform():
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(move_speed * platform_center)
	
	var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
	platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(WAIT_DURATION)
