extends Button



func _process(_delta):
	disabled = !NodeManager.get_undo().has_undo()
	text = str(NodeManager.get_undo_count())

func _on_UndoButton_pressed():
	var _result = NodeManager.get_undo().undo()
