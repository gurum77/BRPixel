extends TextureRectButton
class_name EraserButton

func _ready():
	Util.set_tooltip(self, "Eraser tool", "F")


func _on_EraserButton_pressed():
	run()
func run():
	NodeManager.get_tools().add_child(NodeManager.get_tools().eraser_tool.instance())
	StaticData.last_drawing_tool = NodeManager.get_tools().eraser_tool

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.eraser)


func _on_EraserSettingPopupButton_pressed():
	$EraserSettingPopupButton/EraserSettingPopup.popup_centered()


func _on_EraserButton_gui_input(event):
	run_gui_input(event)
