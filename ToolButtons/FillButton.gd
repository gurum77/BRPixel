extends Button

var fill_tool = preload("res://Tools/Fill.tscn")

func _on_FillButton_pressed():	
	NodeManager.get_tools().add_child(fill_tool.instance())
