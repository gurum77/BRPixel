extends Button



func _on_NextButton_pressed():
	NodeManager.get_canvas().stop()
	StaticData.current_frame_index += 1
	if StaticData.current_frame_index >= NodeManager.get_frames().get_frame_count():
		StaticData.current_frame_index = 0
