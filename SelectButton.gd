extends Button

var select_tool = preload("res://Tools/Select.tscn")

func _on_SelectButton_pressed():
	NodeManager.get_tools().add_child(select_tool.instance())
