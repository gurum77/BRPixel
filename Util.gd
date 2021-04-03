extends Node


# message는 popup으로 보여준다.
func show_message(parent, title="", message=""):
	var dlg = AcceptDialog.new()
	dlg.window_title = title
	dlg.dialog_text = message
	dlg.popup_exclusive = true
	parent.add_child(dlg)
	dlg.popup_centered()
#	var ins = NodeManager.preload_message_popup.instance()
#	# message는 일회성이므로 hide할때 삭제한다.
#	ins.queue_free_on_hide = true
#	parent.add_child(ins)
#	show_child_popup(parent, ins)
	
