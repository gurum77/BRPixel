extends TextureButton
class_name AddFrameButtonOnFramePanel

func _ready():
	Util.set_tooltip(self, tr("Add new frame"), "")
	
func _on_AddFrameButtonOnFramePanel_pressed():
	var _frame = NodeManager.get_frames().add_frame()
	
	StaticData.current_frame_index = NodeManager.get_frames().get_child_count()-1
	
	# frame button 갱신
	NodeManager.get_frame_panel().regen_frame_buttons()
	
	# layer button 갱신
	NodeManager.get_layer_panel().regen_layer_buttons()
	
	
