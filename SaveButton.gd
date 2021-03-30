extends Button

	
func _on_SaveButton_pressed():
	$FileDialog.popup_centered()
	$FileDialog.show()

func _on_FileDialog_file_selected(path):
	var ext = $FileDialog.current_file.get_extension()
	if ext == "pex":
		StaticData.save_project(path)
