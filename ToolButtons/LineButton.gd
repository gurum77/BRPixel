extends Button

func _on_LineButton_pressed():
	NodeManager.get_tools().add_child(NodeManager.get_tools().line_tool.instance())
	Util.set_submenu_popup_button_current_tool(self, NodeManager.get_tools().line_tool)
	StaticData.last_drawing_tool = NodeManager.get_tools().line_tool
	
func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.line)

