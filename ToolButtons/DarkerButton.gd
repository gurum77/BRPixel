extends Button

func _on_DarkerButton_pressed():
	NodeManager.get_tools().add_child(NodeManager.get_tools().darker_tool.instance())
	StaticData.last_drawing_tool = NodeManager.get_tools().darker_tool
	
func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.darker)

