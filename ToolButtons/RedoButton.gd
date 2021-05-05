extends Button


func _process(_delta):
	disabled = !NodeManager.get_undo().has_redo()

func _on_RedoButton_pressed():
	NodeManager.get_tools().finish_selected_area_editing()
	var _result = NodeManager.get_undo().redo()
