extends Button

func _on_OpenFileDialog_file_selected(path):
	var ext = $OpenFileDialog.current_file.get_extension()
	if ext == "pex":
		StaticData.open_project(path)


func _on_OpenButton_pressed():
	$OpenFileDialog.popup_centered()
	$OpenFileDialog.show()

