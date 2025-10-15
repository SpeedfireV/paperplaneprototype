class_name AnimationArea extends Area3D


@onready var camera = $Camera3D

var current_rotation: float

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D):
	if body is PaperPlane:
		GameManager.switch_camera(camera)

func _on_body_exited(body: Node3D):
	if body is PaperPlane:
		GameManager.switch_camera(GameManager.paper_plane.camera)
	

func _process(delta):
	camera.look_at(self.global_position)
	camera.global_position = GameManager.paper_plane.global_position +   (GameManager.paper_plane.global_position - global_position).normalized() * 12 + Vector3.UP 