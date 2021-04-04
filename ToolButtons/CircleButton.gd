extends Button

export var fill = false
var circle_tool = preload("res://Tools/Circle.tscn")

func _on_CircleButton_pressed():
	var circle = circle_tool.instance()
	circle.fill = fill
	NodeManager.get_tools().add_child(circle)
