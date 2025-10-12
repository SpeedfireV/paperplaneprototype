extends CanvasLayer


func _ready():
	GameManager.game_paused_changed.connect(_on_game_paused_changed)

func _on_game_paused_changed(is_paused: bool):
	if is_paused:
		hide_hud()
	else:
		show_hud()

func show_hud():
	visible = true

func hide_hud():
	visible = false
