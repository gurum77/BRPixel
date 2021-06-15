extends Button
class_name RectangleButton
export var fill = false

func _on_RectangleButton_pressed():
	run()
	
func run():
	var rectangle = NodeManager.get_tools().rectangle_tool.instance()
	rectangle.fill = fill
	NodeManager.get_tools().add_child(rectangle)
	
	StaticData.last_drawing_tool = NodeManager.get_tools().rectangle_tool
	StaticData.fill_for_last_drawing_tool = fill
	
	Util.set_submenu_popup_button_current_tool(self, StaticData.Tool.rectangle)
	

func _process(_delta):
	var is_current_tool = false
	if StaticData.current_tool == StaticData.Tool.rectangle:
		var nodes = NodeManager.get_tools().get_children()
		for node in nodes:
			if node is RectangleTool:
				if node.fill == fill:
					is_current_tool = true
					break;
	
	if pressed != is_current_tool:
		pressed = is_current_tool
