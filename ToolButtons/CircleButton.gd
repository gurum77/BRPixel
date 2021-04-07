extends Button

export var fill = false

func _on_CircleButton_pressed():
	var circle = NodeManager.get_tools().circle_tool.instance()
	circle.fill = fill
	NodeManager.get_tools().add_child(circle)
	
	StaticData.last_drawing_tool = NodeManager.get_tools().circle_tool
	StaticData.fill_for_last_drawing_tool = fill
	
func _process(delta):
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
