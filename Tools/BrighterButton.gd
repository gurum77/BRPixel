extends TextureRectButton
class_name BrighterButton


func _ready():
	Util.set_tooltip(self, tr("Brighten tool"), "Shfit+D")
	
func _on_BrighterButton_pressed():
	run()
func run():
	NodeManager.get_tools().add_child(NodeManager.get_tools().brighter_tool.instance())
	StaticData.last_drawing_tool = NodeManager.get_tools().brighter_tool

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.brighter)



func _on_BrighterButton_gui_input(event):
	run_gui_input(event)
