extends TextureRectButton




func _on_BrighterButton_pressed():
	NodeManager.get_tools().add_child(NodeManager.get_tools().brighter_tool.instance())
	StaticData.last_drawing_tool = NodeManager.get_tools().brighter_tool

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.brighter)



func _on_BrighterButton_gui_input(event):
	run_gui_input(event)
