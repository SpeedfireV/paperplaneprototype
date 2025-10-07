class_name PaperPlane extends CharacterBody3D

@export_category("Movement")
@export var acceleration := 5.0
@export var deceleration := 3.0
@export var max_speed := 10.0
@export var rotation_speed := 1.5
@export_category("Camera")
@export var min_fov := 70.0
@export var max_fov := 90.0
@export var min_angle := -15.0
@export var max_angle := -20.0
@export var min_camera_position := Vector3(0, 0.4, 0.65)
@export var max_camera_position := Vector3(0, 0.5, 0.9)


@onready var plane_mesh : MeshInstance3D = $PlaneMesh
@onready var camera: Camera3D = $CameraGrip/Camera3D
@onready var camera_grip: Node3D = $CameraGrip

var current_speed := 0.0

func _physics_process(delta):
	var accel_input := Input.get_axis("speed_down", "speed_up")
	var rotation_input := Input.get_vector("rotate_right", "rotate_left" , "rotate_up", "rotate_down")
	var steer_input := Input.get_axis("steer_left", "steer_right")

	if accel_input > 0:
		current_speed = min(current_speed + acceleration * delta, max_speed)
	elif accel_input < 0:
		current_speed = max(current_speed - deceleration * delta, 0)
	else:
		current_speed = move_toward(current_speed, 0, deceleration * delta)

	rotate_object_local(Vector3.FORWARD, -rotation_input.x * rotation_speed * delta) 
	rotate_object_local(Vector3.RIGHT, rotation_input.y * rotation_speed * delta)

	if steer_input > 0:
		plane_mesh.rotation.z = lerp(plane_mesh.rotation.z, -0.5 * steer_input, 0.1)
	elif steer_input < 0:
		plane_mesh.rotation.z = lerp(plane_mesh.rotation.z, -0.5 * steer_input, 0.1)
	else:
		plane_mesh.rotation.z = lerp(plane_mesh.rotation.z, 0., 0.1)

	rotate_object_local(Vector3.DOWN, steer_input * rotation_speed * delta)


	var forward_dir = -transform.basis.z
	velocity = forward_dir * current_speed
	# velocity += get_gravity()

	move_and_slide()

	camera.fov = lerp(min_fov, max_fov, current_speed / max_speed)
	# camera.rotation.x = lerp(min_angle, max_angle, current_speed / max_speed)
	camera_grip.position = lerp(min_camera_position, max_camera_position, current_speed / max_speed)


	print("Speed:", current_speed, "Velocity:", velocity)
