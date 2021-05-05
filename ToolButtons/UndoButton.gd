extends Button



func _process(_delta):
	disabled = !NodeManager.get_undo().has_undo()
	text = str(NodeManager.get_undo_count())

func _on_UndoButton_pressed():
	NodeManager.get_tools().finish_selected_area_editing()
	var _result = NodeManager.get_undo().undo()
