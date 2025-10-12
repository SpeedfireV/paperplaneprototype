class_name PaperPlane extends CharacterBody3D

@export_category("Movement")
@export var acceleration := 3.0
@export var deceleration := 2.0
@export var max_speed := 10.0
@export var rotation_speed := 0.8
@export var min_speed := 2
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
		current_speed = move_toward(current_speed, 5, deceleration * delta)

	rotate_object_local(Vector3.FORWARD, -rotation_input.x * rotation_speed * delta) 
	rotate_object_local(Vector3.RIGHT, rotation_input.y * rotation_speed * delta)

	if rotation_input.y > 0:
		plane_mesh.rotation.x = lerp(plane_mesh.rotation.x, rotation_input.y * PI / 9, 0.5 * delta * current_speed)
	elif rotation_input.y < 0:
		plane_mesh.rotation.x = lerp(plane_mesh.rotation.x, rotation_input.y * PI / 9, 0.5 * delta * current_speed)
	else:
		plane_mesh.rotation.x = lerp(plane_mesh.rotation.x, 0., 0.75 * delta * current_speed)

	if rotation_input.x > 0:
		plane_mesh.rotation.z = lerp(plane_mesh.rotation.z, rotation_input.x * PI / 8, 0.5 * delta * current_speed)
	elif rotation_input.x < 0:
		plane_mesh.rotation.z = lerp(plane_mesh.rotation.z, rotation_input.x * PI / 8, 0.5 * delta * current_speed)
	else:
		plane_mesh.rotation.z = lerp(plane_mesh.rotation.z, 0., 0.75 * delta * current_speed)

	if steer_input > 0:
		plane_mesh.rotation.y = lerp(plane_mesh.rotation.y, -0.1 * steer_input * PI, 0.5 * delta * current_speed)
	elif steer_input < 0:
		plane_mesh.rotation.y = lerp(plane_mesh.rotation.y, -0.1 * steer_input * PI, 0.5 * delta * current_speed)
	else:
		plane_mesh.rotation.y = lerp(plane_mesh.rotation.y, 0., 0.75 * delta * current_speed)

	# Iloczyn skalarny wektora skierowanego do przodu samolotu i wektora skierowanego w dół
	# -> Kąt nachylenia samolotu
	var forward = -transform.basis.z
	var downward_amount = forward.dot(Vector3.DOWN)

	print(current_speed)
	
	if downward_amount < -0.3:
		current_speed = max(current_speed - acceleration * delta * abs(downward_amount), min_speed)
	elif downward_amount > 0.2:
		current_speed = min(current_speed + acceleration * 2 * delta * abs(downward_amount), max_speed)

	if rotation.x > PI / 6:
		rotation.x = lerp(rotation.x, 0., delta)

	rotate_object_local(Vector3.DOWN, -rotation_input.x * rotation_speed * delta)
	rotate_object_local(Vector3.DOWN, 0.25 * steer_input * rotation_speed * delta)

	rotation.z = lerp(rotation.z, 0., (0.05 + max(0, abs(rotation.z) - PI / 4) * 0.5) * current_speed * delta)

	rotation.x += -0.1 * delta

	var forward_dir = -transform.basis.z
	velocity = forward_dir * current_speed

	move_and_slide()

	var camera_grip_vector := (max_camera_position - min_camera_position).normalized()
	var orthogonal_grip_vector := camera_grip_vector.cross(Vector3.FORWARD).normalized() # Horyzontalna "szyna" kamery - ruch w lewo/prawo
	var target_camera_position = min_camera_position + (max_camera_position - min_camera_position) * (current_speed / max_speed)

	if steer_input != 0:
		target_camera_position += orthogonal_grip_vector * steer_input * 0.1 * (current_speed / max_speed) * 2.5

	camera.fov = lerp(min_fov, max_fov, current_speed / max_speed)
	# camera.rotation.x = lerp(min_angle, max_angle, current_speed / max_speed)

	camera_grip.position = lerp(camera_grip.position, target_camera_position, delta)
