extends Button

var rectangle_tool = preload("res://Tools/Rectangle.tscn")

func _on_RectangleButton_pressed():
	NodeManager.get_tools().add_child(rectangle_tool.instance())
