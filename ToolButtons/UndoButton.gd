extends Button



func _process(_delta):
	disabled = !UndoRedoManager.undo_redo.has_undo()
	text = str(UndoRedoManager.undo_count)

func _on_UndoButton_pressed():
	var _result = UndoRedoManager.undo_redo.undo()
