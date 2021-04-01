extends Button



func _on_CanvasSizeButton_pressed():
	if NodeManager.get_setting_window() != null:
		NodeManager.get_setting_window().set_active(false)
	$CanvasSizeWindow.popup_centered()
	$CanvasSizeWindow.visible = true




func _on_CanvasSizeWindow_hide():
	if NodeManager.get_setting_window() != null:
		NodeManager.get_setting_window().set_active(true)
