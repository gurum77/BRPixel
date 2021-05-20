extends Button



func _process(_delta):
	var undo = NodeManager.get_undo()
	if undo == null:
		return
	disabled = !undo.has_undo()
#	text = str(NodeManager.get_undo_count())

func on_UndoButton_pressed():
	var undo = NodeManager.get_undo()
	if undo == null:
		return
	NodeManager.get_tools().finish_selected_area_editing()
	var _result = undo.undo()
