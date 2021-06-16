extends Button
class_name LineButton
func _ready():
	Util.set_tooltip(self, "Line tool", "L")

	
func run():
	NodeManager.get_tools().add_child(NodeManager.get_tools().line_tool.instance())
	Util.set_submenu_popup_button_current_tool(self, StaticData.Tool.line, hint_tooltip)
	StaticData.last_drawing_tool = NodeManager.get_tools().line_tool
	
func _on_LineButton_pressed():
	run()
	
func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.line)

