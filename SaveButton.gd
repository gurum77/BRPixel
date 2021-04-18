extends Button

export var save_selected_area = false
	
func _ready():
	# android는 user 폴더에 접근하도록 설정해야함
	if OS.get_name() == "Windows":
		$SaveFileDialog.access = FileDialog.ACCESS_FILESYSTEM
	else:
		$SaveFileDialog.access = FileDialog.ACCESS_USERDATA
		
func _on_SaveButton_pressed():
	var _tmp = NodeManager.get_file_dialog().connect("hide", self, "on_hide_file_dialog")
	if save_selected_area:
		NodeManager.get_file_dialog().filters = PoolStringArray(["*.png;PNG", "*.jpg;JPEG"])
	else:
		NodeManager.get_file_dialog().filters = PoolStringArray(["*.pex;Pixel Express", "*.png;PNG", "*.jpg;JPEG"])
	NodeManager.get_file_dialog().popup_centered()
	
func on_hide_file_dialog():
	NodeManager.get_file_dialog().disconnect("hide", self, "on_hide_file_dialog")
	if !NodeManager.get_file_dialog().result_ok:
		return
			
	for selected_file in NodeManager.get_file_dialog().selected_file_paths:
		var ext = selected_file.get_extension()
		ext = ext.to_lower()
		if ext == "pex":
			StaticData.save_project(selected_file)
		else:
			var error = StaticData.save_image(selected_file, save_selected_area)
			if error != OK:
				Util.show_error_message(self, error)
			else:
				Util.show_message(self, "Save", "Save completed")
		

#	if save_selected_area:
#		$SaveFileDialog.filters = PoolStringArray(["*.png;PNG", "*.jpg;JPEG"])
#	else:
#		$SaveFileDialog.filters = PoolStringArray(["*.pex;Pixel Express", "*.png;PNG", "*.jpg;JPEG"])
#	$SaveFileDialog.popup_centered()
#	$SaveFileDialog.show()


			
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

