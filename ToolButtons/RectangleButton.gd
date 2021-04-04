extends Button

var rectangle_tool = preload("res://Tools/Rectangle.tscn")
export var fill = false

func _on_RectangleButton_pressed():
	var rectangle = rectangle_tool.instance()
	rectangle.fill = fill
	NodeManager.get_tools().add_child(rectangle)
