extends Button



func _on_FillButton_pressed():	
	NodeManager.get_tools().add_child(NodeManager.get_tools().fill_tool.instance())
	# fill은 last drawing tool에 등록하지 말자.(당황스러운 상황이 많이 발생함)
#	StaticData.last_drawing_tool = NodeManager.get_tools().fill_tool
	
	

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.fill)
