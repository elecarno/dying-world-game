extends CharacterBody3D

@onready var cam: Camera3D = get_node("head/cam")
@onready var head: Node3D = get_node("head")
@onready var pivot: Node3D = get_node("pivot")
@onready var player: CharacterBody3D = get_node("../player")

var speed: float
const BASE_SPEED: float = 45.0
const BOOST_SPEED: float = 75.0
const JUMP_VELOCITY: float = 20.0
const SENSITIVITY: float = 0.001

const BASE_FOV: float = 75.0
const FOV_CHANGE: float = 0.5

var gravity = 19.6

func _unhandled_input(event):
	if event is InputEventMouseMotion and player_stats.is_mounted:
		pivot.rotate_y(-event.relative.x * SENSITIVITY)
		cam.rotate_x(-event.relative.y * SENSITIVITY)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-10), deg_to_rad(25))

func _physics_process(delta):
	head.rotation.y = lerp(head.rotation.y, pivot.rotation.y, delta * 2.0)
	
	if Input.is_action_just_pressed("vehicle"):
		player_stats.is_mounted = !player_stats.is_mounted
		if player_stats.is_mounted:
			cam.current = true
			axis_lock_linear_x = false
			axis_lock_linear_z = false
			global_position = player.global_position
			visible = true
		else:
			axis_lock_linear_x = true
			axis_lock_linear_z = true
			visible = false
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("mov_jump") and is_on_floor() and player_stats.is_mounted:
		velocity.y = JUMP_VELOCITY

	elif Input.is_action_pressed("mov_sprint"):
		speed = BOOST_SPEED
	else:
		speed = BASE_SPEED

	var input_dir = Input.get_vector("mov_left", "mov_right", "mov_forward", "mov_backward")
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if player_stats.is_mounted:
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	var velocity_clamped = clamp(velocity.length(), 0.5, BOOST_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	cam.fov = lerp(cam.fov, target_fov, delta * 8.0)

	move_and_slide()
