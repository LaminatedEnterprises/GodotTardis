extends CharacterBody3D
class_name Player3D


@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5
@export var yaw_speed: float = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	
	rotate_y(rel_motion.x * yaw_speed)
	rel_motion = Vector2.ZERO
	
var rel_motion = Vector2.ZERO
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rel_motion = event.relative

func get_camera() -> Camera3D:
	return $Camera3D
