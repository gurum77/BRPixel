extends Button


func _process(_delta):
	disabled = !UndoRedoManager.undo_redo.has_redo()

func _on_RedoButton_pressed():
	UndoRedoManager.undo_redo.redo()
