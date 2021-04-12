extends Button


var darker_tool = preload("res://Tools/Darker.tscn")

func _on_DarkerButton_pressed():
	var ins = darker_tool.instance()
	NodeManager.get_tools().add_child(ins)
	
func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.darker)

