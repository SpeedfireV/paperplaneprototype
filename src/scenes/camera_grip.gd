class_name CameraGrip extends Node3D

@export var plane: PaperPlane
@export_category("Camera")
@export var min_fov := 70.0
@export var max_fov := 90.0
@export var min_angle := -15.0
@export var max_angle := -20.0
@export var min_camera_position := Vector3(0, 0.4, 0.65)
@export var max_camera_position := Vector3(0, 0.5, 0.9)

@onready var camera: Camera3D = $Camera3D


func _process(delta):
	rotation = plane.rotation
	var camera_grip_vector := (max_camera_position - min_camera_position).normalized()
	var orthogonal_grip_vector := camera_grip_vector.cross(Vector3.FORWARD).normalized() # Horyzontalna "szyna" kamery - ruch w lewo/prawo
	var target_camera_position = min_camera_position + (max_camera_position - min_camera_position) * (plane.current_speed / plane.max_speed)

	if plane.steer_input != 0:
		target_camera_position += orthogonal_grip_vector * plane.steer_input * 0.1 * (plane.current_speed / plane.max_speed) * 2.5

	camera.fov = lerp(min_fov, max_fov, plane.current_speed / plane.max_speed)
	# camera.rotation.x = lerp(min_angle, max_angle, current_speed / max_speed)

	camera.look_at(plane.global_transform.origin, Vector3.UP)

	global_position = lerp(global_position, target_camera_position, 0.1)


func look_at_target(target: Vector3):
	look_at(target, Vector3.UP)

func move_towards_target(target: Vector3, speed: float, delta: float):
	var direction = (target - global_transform.origin).normalized()
	global_transform.origin += lerp(Vector3.ZERO, direction * speed, delta)