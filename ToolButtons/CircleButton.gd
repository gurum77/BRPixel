extends Button
class_name CircleButton
export var fill = false

func _on_CircleButton_pressed():
	pass
func run():
	var circle = NodeManager.get_tools().circle_tool.instance()
	circle.fill = fill
	NodeManager.get_tools().add_child(circle)
	
	StaticData.last_drawing_tool = NodeManager.get_tools().circle_tool
	StaticData.fill_for_last_drawing_tool = fill
	
	Util.set_submenu_popup_button_current_tool(self, StaticData.Tool.circle)
	
func _process(_delta):
	var is_current_tool = false
	if StaticData.current_tool == StaticData.Tool.circle:
		var nodes = NodeManager.get_tools().get_children()
		for node in nodes:
			if node is CircleTool:
				if node.fill == fill:
					is_current_tool = true
					break;
	
	if pressed != is_current_tool:
		pressed = is_current_tool


func _on_CircleButton_button_up():
	run()
