extends Button

export var save_selected_area = false
	
func _on_SaveButton_pressed():
	if save_selected_area:
		$SaveFileDialog.filters = PoolStringArray(["*.png;PNG", "*.jpg;JPEG"])
	else:
		$SaveFileDialog.filters = PoolStringArray(["*.pex;Pixel Express", "*.png;PNG", "*.jpg;JPEG"])
	$SaveFileDialog.popup_centered()
	$SaveFileDialog.show()

func _on_SaveFileDialog_file_selected(path):
	var ext = $SaveFileDialog.current_file.get_extension()
	ext = ext.to_lower()
	if ext == "pex":
		StaticData.save_project(path)
	else:
		var error = StaticData.save_image(path, save_selected_area)
		if error != OK:
			Util.show_error_message(self, error)
		else:
			Util.show_message(self, "Save", "Save completed")

