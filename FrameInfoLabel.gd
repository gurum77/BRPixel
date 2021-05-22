extends Label


func _process(_delta):
	text = "%d / %d" % [StaticData.current_frame_index+1, NodeManager.get_frames().get_frame_count()]
