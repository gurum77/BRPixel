extends Button


var brighter_tool = preload("res://Tools/Brighter.tscn")

func _on_BrighterButton_pressed():
	var ins = brighter_tool.instance()
	NodeManager.get_tools().add_child(ins)
	
func _process(delta):
	Util.press_current_tool_button(self, StaticData.Tool.brighter)

