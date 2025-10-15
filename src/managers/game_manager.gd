extends Node

signal game_paused_changed(is_paused: bool)

var current_camera: EnhancedCamera
var mimic_camera: Camera3D
var paper_plane: PaperPlane:
	set(value):
		paper_plane = value
		current_camera = paper_plane.camera
		mimic_camera.global_position = current_camera.global_transform.origin
		mimic_camera.global_transform.basis = current_camera.global_transform.basis
		mimic_camera.fov = current_camera.fov
		mimic_camera.current = true
		mimic_camera.rotation = current_camera.rotation

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if Input.is_action_just_pressed("pause"):
		pause_game()


func pause_game():
	if get_tree().paused:
		get_tree().paused = false
	else:
		get_tree().paused = true

	game_paused_changed.emit(not get_tree().paused)

func _process(delta):
	mimic_camera.global_position = lerp(mimic_camera.global_position, current_camera.global_position, 0.04)
	mimic_camera.rotation = lerp(mimic_camera.rotation, current_camera.real_rotation, 0.04)
	mimic_camera.fov = lerp(mimic_camera.fov, current_camera.fov, 0.04)



func switch_camera(camera: Camera3D):
	if current_camera == camera:
		return
	current_camera = camera
