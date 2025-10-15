extends EnhancedCamera

@export var paper_plane: PaperPlane

func _process(delta):
	real_rotation = paper_plane.rotation
	
