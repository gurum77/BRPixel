extends Button
var pickcolor_tool = preload("res://Tools/PickColorFromCanvas.tscn")
func _on_PickColorFromCanvasButton_pressed():
	NodeManager.get_tools().add_child(pickcolor_tool.instance())

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.pick_color_from_canvas)
		
