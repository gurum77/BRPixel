extends Button

	
func _ready():
	Util.set_tooltip(self, tr("Save selected area as image"),"")
# save option popup이 닫히면 파일 dialog를 띄운다.
func on_SaveOptionsPopup_hide():
		
	# ok를 누르면 파일명을 입력받고 저장을 한다.
	var _tmp = NodeManager.get_file_dialog().connect("hide", self, "on_hide_file_dialog")
	NodeManager.get_file_dialog().filters = PoolStringArray(["*.png;PNG", "*.jpg;JPEG"])
	NodeManager.get_file_dialog().default_file_name = ""
	NodeManager.get_file_dialog().save_file_dialog = true
	NodeManager.get_file_dialog().popup_centered()
	
# file dialog가 닫히면 선택한 옵션과 파일명으로 저장한다.
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
			var sprite_sheet = NodeManager.get_save_options_popup().sprite_sheets_method
			var scale = NodeManager.get_save_options_popup().get_image_scale()
			var error = StaticData.save_image(selected_file, true, sprite_sheet, scale)
			if error != OK:
				Util.show_error_message(self, error)
			else:
				Util.show_message(self, "Save", "Save completed")
		

			
func _on_SaveFileDialog_file_selected(path):
	var ext = $SaveFileDialog.current_file.get_extension()
	ext = ext.to_lower()
	if ext == "pex":
		StaticData.save_project(path)
	else:
		var error = StaticData.save_image(path, true)
		if error != OK:
			Util.show_error_message(self, error)
		else:
			Util.show_message(self, "Save", "Save completed")

func _process(_delta):
	disabled = !StaticData.enabled_selected_area()


func _on_SaveSelectedAreaButton_pressed():
	NodeManager.get_setting_popup().hide()
	on_SaveOptionsPopup_hide()
