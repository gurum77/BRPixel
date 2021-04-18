extends Button

func _on_PencilButton_pressed():
	run()
	
func run():
	NodeManager.get_tools().add_child(NodeManager.get_tools().pencil_tool.instance())
	StaticData.last_drawing_tool = NodeManager.get_tools().pencil_tool

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.pencil)



func _on_PencilSettingButton_pressed():
	$PencilSettingButton/PencilSettingPopup.popup_centered()
