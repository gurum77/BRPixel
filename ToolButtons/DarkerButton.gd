extends TextureRectButton
class_name DarkerButton

func _ready():
	Util.set_tooltip(self, tr("Darken tool"), "D")
	
func _on_DarkerButton_pressed():
	run()
	
func run():
	NodeManager.get_tools().add_child(NodeManager.get_tools().darker_tool.instance())
	StaticData.last_drawing_tool = NodeManager.get_tools().darker_tool
	
func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.darker)



func _on_DarkerButton_gui_input(event):
	run_gui_input(event)
