extends Button



func _on_FillButton_pressed():	
	NodeManager.get_tools().add_child(NodeManager.get_tools().fill_tool.instance())
	StaticData.last_drawing_tool = NodeManager.get_tools().fill_tool
	
	

func _process(delta):
	Util.press_current_tool_button(self, StaticData.Tool.fill)
