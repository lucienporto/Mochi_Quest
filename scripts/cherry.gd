extends EnemyBase

func _ready():
	sprite = $Sprite2D
	anim.animation_finished.connect(kill_ground_enemy)

func _physics_process(delta):
	apply_gravity(delta)
	movement(delta)
