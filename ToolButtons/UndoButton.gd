extends Button



func _process(_delta):
	disabled = !StaticData.undo_redo.has_undo()
	text = str(StaticData.undo_count)

func _on_UndoButton_pressed():
	var _result = StaticData.undo_redo.undo()
