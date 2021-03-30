extends Button

func _on_FileDialog_file_selected(path):
	var ext = $FileDialog.current_file.get_extension()
	if ext == "pex":
		StaticData.open_project(path)


func _on_OpenButton_pressed():
	$FileDialog.popup_centered()
	$FileDialog.show()
