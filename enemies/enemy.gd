extends CharacterBody2D

@onready var wall_detector: RayCast2D = $WallDetector
@onready var sprite: Sprite2D = $Sprite2D

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: int = -1


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		sprite.scale.x *= -1

	velocity.x = direction * SPEED * delta

	move_and_slide()
