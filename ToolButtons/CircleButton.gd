extends Button

var circle_tool = preload("res://Tools/Circle.tscn")

func _on_CircleButton_pressed():
	NodeManager.get_tools().add_child(circle_tool.instance())
