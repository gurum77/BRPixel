extends TextureButton
class_name AddFrameButtonOnFramePanel

func _on_AddFrameButtonOnFramePanel_pressed():
	NodeManager.get_current_frames().add_frame()
	StaticData.current_frame_index = NodeManager.get_current_frames().get_child_count()-1
	
	# frame button 갱신
	NodeManager.get_frame_panel().regen_frame_buttons()
	
	# layer button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
