extends Button

var pencil_tool = preload("res://Tools/Pencil.tscn")

func _on_PencilButton_pressed():
	NodeManager.get_tools().add_child(pencil_tool.instance())
