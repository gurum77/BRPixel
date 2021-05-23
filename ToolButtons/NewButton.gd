extends TextureRectButton

func _on_NewButton_pressed():
	$NewPopup.popup_centered()


func _on_NewButton_gui_input(event):
	run_gui_input(event)
