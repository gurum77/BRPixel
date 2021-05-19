extends Label


func _process(_delta):
	var frames = NodeManager.get_frames()
	var cur_frame = NodeManager.get_current_frame()
	if frames == null || cur_frame == null:
		return
	var project_name = StaticData.project_name
	var w = StaticData.canvas_width
	var h = StaticData.canvas_height
	text = "%s - %d x %d, %d frames, %d layers" % [project_name, w, h, frames.get_frame_count(), cur_frame.get_layers().get_child_count()]
