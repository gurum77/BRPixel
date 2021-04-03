extends Button

	
func _on_SaveButton_pressed():
	$SaveFileDialog.popup_centered()
	$SaveFileDialog.show()

func _on_SaveFileDialog_file_selected(path):
	var ext = $SaveFileDialog.current_file.get_extension()
	if ext == "pex":
		StaticData.save_project(path)

