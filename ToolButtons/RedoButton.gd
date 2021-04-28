extends Button


func _process(_delta):
	disabled = !StaticData.undo_redo.has_redo()

func _on_RedoButton_pressed():
	var _result = StaticData.undo_redo.redo()
