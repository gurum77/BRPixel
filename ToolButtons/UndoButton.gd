extends Button



func _process(_delta):
	disabled = !UndoRedoManager.undo_redo.has_undo()

func _on_UndoButton_pressed():
	UndoRedoManager.undo_redo.undo()
