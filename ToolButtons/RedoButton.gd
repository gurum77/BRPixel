extends TextureRectButton


func _process(_delta):
	var undo = NodeManager.get_undo()
	if undo == null:
		return
	disabled = !undo.has_redo()

func on_RedoButton_pressed():
	var undo = NodeManager.get_undo()
	if undo == null:
		return
	NodeManager.get_tools().finish_selected_area_editing()
	var _result = undo.redo()


func _on_RedoButton_gui_input(event):
	run_gui_input(event)
