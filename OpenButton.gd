extends Button

export var add_image = false
onready var file_dialog = $OpenFileDialog
func _ready():
	# android는 user 폴더에 접근하도록 설정해야함
	if OS.get_name() == "Windows":
		file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	else:
		file_dialog.access = FileDialog.ACCESS_USERDATA
	
func _on_OpenFileDialog_file_selected(path):
		
	if add_image:
		# 파일을 image로 로딩
		var image:Image = Util.load_image_file(self, path)
		if image == null:
			return
		
		Util.AttachImageWithEditTool(image, Vector2(0, 0))
	else:
		var ext = file_dialog.current_file.get_extension()
		ext = ext.to_lower()
		if ext == "pex":
			StaticData.open_project(path)
		else:
			StaticData.open_image(self, path)
		
		


func _on_OpenButton_pressed():
	var _tmp = NodeManager.get_file_dialog().connect("hide", self, "on_hide_file_dialog")
	if add_image:
		NodeManager.get_file_dialog().filters = PoolStringArray(["*.png;PNG Image", "*.jpg,*.jpeg;JPEG Image", "*.bmp ; BMP Image", "*.hdr;Radiance HDR Image", "*.svg ; SVG Image", "*.tga ; TGA Image", "*.webp ; WebP Image"])
	else:
		NodeManager.get_file_dialog().filters = PoolStringArray(["*.pex;Pixel Express", "*.png;PNG Image", "*.jpg,*.jpeg;JPEG Image", "*.bmp ; BMP Image", "*.hdr;Radiance HDR Image", "*.svg ; SVG Image", "*.tga ; TGA Image", "*.webp ; WebP Image"])
	NodeManager.get_file_dialog().popup_centered()

func on_hide_file_dialog():
	NodeManager.get_file_dialog().disconnect("hide", self, "on_hide_file_dialog")
	if !NodeManager.get_file_dialog().result_ok:
		return
	
	var file_path = NodeManager.get_file_dialog().get_last_selected_file_path()
	if file_path == null || file_path == "":
		return
		
	if add_image:
		# 파일을 image로 로딩
		var image:Image = Util.load_image_file(self, file_path)
		if image == null:
			return
		
		Util.AttachImageWithEditTool(image, Vector2(0, 0))
	else:
		
		var ext = file_path.get_extension()
		ext = ext.to_lower()
		if ext == "pex":
			StaticData.open_project(file_path)
		else:
			StaticData.open_image(self, file_path)

#	if add_image:
#		file_dialog.filters = PoolStringArray(["*.png;PNG Image", "*.jpg,*.jpeg;JPEG Image", "*.bmp ; BMP Image", "*.hdr;Radiance HDR Image", "*.svg ; SVG Image", "*.tga ; TGA Image", "*.webp ; WebP Image"])
#	else:
#		file_dialog.filters = PoolStringArray(["*.pex;Pixel Express", "*.png;PNG Image", "*.jpg,*.jpeg;JPEG Image", "*.bmp ; BMP Image", "*.hdr;Radiance HDR Image", "*.svg ; SVG Image", "*.tga ; TGA Image", "*.webp ; WebP Image"])
#	file_dialog.current_dir = "user://"
#	file_dialog.invalidate()
#	file_dialog.popup_centered()
#	file_dialog.show()

