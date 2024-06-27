extends EnemyBase

func _ready():
	wall_detector = $WallDetector
	sprite = $Sprite2D
	anim.animation_finished.connect(kill_ground_enemy)

func _physics_process(delta):
	apply_gravity(delta)
	movement(delta)
	flip_direction()
