extends EnemyBase

@onready var ground_detector = $GroundDetector

func _ready():
	sprite = $Sprite2D
	wall_detector = $WallDetector
	anim.animation_finished.connect(kill_ground_enemy)

func _physics_process(delta):
	apply_gravity(delta)
	movement(delta)
	
	if is_on_wall():
		flip_enemy()
	

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
