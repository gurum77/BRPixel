extends Label


func _process(delta):
	text = "%3d of %3d frames" % [StaticData.current_frame_index+1, NodeManager.get_frames().get_frame_count()]
