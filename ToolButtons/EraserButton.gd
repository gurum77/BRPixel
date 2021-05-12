extends Button

func _on_EraserButton_pressed():
	NodeManager.get_tools().add_child(NodeManager.get_tools().eraser_tool.instance())
	StaticData.last_drawing_tool = NodeManager.get_tools().eraser_tool

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.eraser)


func _on_EraserSettingPopupButton_pressed():
	$EraserSettingPopupButton/EraserSettingPopup.popup_centered()
