extends Button

var line_tool = preload("res://Tools/Line.tscn")

func _on_LineButton_pressed():
	NodeManager.get_tools().add_child(line_tool.instance())
	
func _process(delta):
	Util.press_current_tool_button(self, StaticData.Tool.line)
