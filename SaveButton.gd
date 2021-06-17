extends TextureRectButton
class_name SaveButton
export var save_selected_area = false

func _ready():
	Util.set_tooltip(self, tr("Save project"), "Ctrl+S")
		
func run():
	_on_SaveButton_pressed()
	
func _on_SaveButton_pressed():
	NodeManager.get_setting_popup().hide()
	if !save_selected_area:
		var _result = NodeManager.get_save_options_popup().connect("hide", self, "on_SaveOptionsPopup_hide")
		NodeManager.get_save_options_popup().popup_centered()
	else:
		on_SaveOptionsPopup_hide()
	
# save option popup이 닫히면 파일 dialog를 띄운다.
func on_SaveOptionsPopup_hide():
	if !save_selected_area:
		NodeManager.get_save_options_popup().disconnect("hide", self, "on_SaveOptionsPopup_hide")
		if NodeManager.get_save_options_popup().result != SaveOptionsPopup.Result.ok:
			return
		
	# ok를 누르면 파일명을 입력받고 저장을 한다.
	var _tmp = NodeManager.get_file_dialog().connect("hide", self, "on_hide_file_dialog")
	if save_selected_area:
		NodeManager.get_file_dialog().filters = PoolStringArray(["*.png;PNG", "*.jpg;JPEG"])
		NodeManager.get_file_dialog().default_file_name = ""
	else:
		if NodeManager.get_save_options_popup().format == SaveOptionsPopup.Format.pex:
			NodeManager.get_file_dialog().filters = PoolStringArray(["*.pex;BRPixel"])
		elif NodeManager.get_save_options_popup().format == SaveOptionsPopup.Format.png:
			NodeManager.get_file_dialog().filters = PoolStringArray(["*.png;PNG"])
		elif NodeManager.get_save_options_popup().format == SaveOptionsPopup.Format.gif:
			NodeManager.get_file_dialog().filters = PoolStringArray(["*.gif;GIF"])
		NodeManager.get_file_dialog().default_file_name = StaticData.project_name
		
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
			Util.show_message(self, "Save", "Save completed")
		else:
			var sprite_sheet = NodeManager.get_save_options_popup().sprite_sheets_method
			var scale = NodeManager.get_save_options_popup().get_image_scale()
			var error = StaticData.save_image(selected_file, save_selected_area, sprite_sheet, scale)
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
		var error = StaticData.save_image(path, save_selected_area)
		if error != OK:
			Util.show_error_message(self, error)
		else:
			Util.show_message(self, "Save", "Save completed")

func _process(_delta):
	if save_selected_area:
		disabled = !StaticData.enabled_selected_area()
	else:
		disabled = false


func _on_SaveButton_gui_input(event):
	run_gui_input(event)
