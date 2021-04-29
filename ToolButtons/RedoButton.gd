extends Button


func _process(_delta):
	disabled = !NodeManager.get_undo().has_redo()

func _on_RedoButton_pressed():
	var _result = NodeManager.get_undo().redo()
