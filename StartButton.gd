extends Button



func _on_StartButton_pressed():
	NodeManager.get_canvas().stop()
	StaticData.current_frame_index = 0
	
