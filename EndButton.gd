extends Button

func _on_EndButton_pressed():
	NodeManager.get_canvas().stop()
	StaticData.current_frame_index = NodeManager.get_frames().get_frame_count()-1
