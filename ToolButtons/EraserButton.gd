extends Button

var eraser_tool = preload("res://Tools/Eraser.tscn")

func _on_EraserButton_pressed():
	NodeManager.get_tools().add_child(eraser_tool.instance())
