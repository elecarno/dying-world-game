extends VehicleBody3D

@onready var cam: Camera3D = get_node("cam_pivot/cam")
@onready var rev_cam: Camera3D = get_node("cam_pivot/rev_cam")
@onready var cam_pivot: Node3D = get_node("cam_pivot")

const MAX_STEER: float = 0.8 # in radians
const ENGINE_POWER: float = 300.0
const MAX_SPEED: float = 20.0 # Maximum speed in units per second

var look_at: Vector3

func _physics_process(delta):
	look_at = global_position
	
	if Input.is_action_just_pressed("interact"):
		player_stats.is_mounted = !player_stats.is_mounted
		if player_stats.is_mounted:
			cam.current = true

	if player_stats.is_mounted:
		steering = move_toward(steering, Input.get_axis("mov_right", "mov_left") * MAX_STEER, delta * 2.5)
		_apply_engine_force(delta)
		cam_pivot.global_position = cam_pivot.global_position.lerp(global_position, delta * 20.0)
		cam_pivot.transform = cam_pivot.transform.interpolate_with(transform, delta * 5.0)
		look_at = look_at.lerp(global_position + linear_velocity, delta * 5.0)
		cam.look_at(look_at)
		rev_cam.look_at(look_at)
		_check_camera_switch()
		
func _apply_engine_force(delta):
	var speed = linear_velocity.length()
	var input_force = Input.get_axis("mov_backward", "mov_forward") * ENGINE_POWER

	# Limit the speed
	if speed >= MAX_SPEED and input_force > 0:
		engine_force = 0
	else:
		engine_force = input_force

func _check_camera_switch():
	if linear_velocity.dot(transform.basis.z) > 0:
		cam.current = true
	else:
		rev_cam.current = true
