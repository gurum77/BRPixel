extends Button

var edit_tool = preload("res://Tools/Edit.tscn")

func _on_EditButton_pressed():
	NodeManager.get_tools().add_child(edit_tool.instance())

func _process(delta):
	Util.press_current_tool_button(self, StaticData.Tool.edit)
