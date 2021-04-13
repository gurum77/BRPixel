extends Button

var eraser_tool = preload("res://Tools/Eraser.tscn")

func _on_EraserButton_pressed():
	NodeManager.get_tools().add_child(eraser_tool.instance())

func _process(_delta):
	Util.press_current_tool_button(self, StaticData.Tool.eraser)


func _on_EraserSettingPopupButton_pressed():
	$EraserSettingPopupButton/EraserSettingPopup.popup_centered()
