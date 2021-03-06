extends TextureRectButton
class_name OpenButton

export var add_image = false

func _ready():
	Util.set_tooltip(self, tr("Open project"), "Ctrl+O")
	
func run():
	_on_OpenButton_pressed()
	
func _on_OpenButton_pressed():
	var _tmp = NodeManager.get_file_dialog().connect("hide", self, "on_hide_file_dialog")
	NodeManager.get_file_dialog().save_file_dialog = false
	if add_image:
		NodeManager.get_file_dialog().filters = PoolStringArray(["*.png;PNG Image", "*.jpg,*.jpeg;JPEG Image", "*.bmp;BMP Image", "*.hdr;Radiance HDR Image", "*.svg;SVG Image", "*.tga;TGA Image", "*.webp;WebP Image"])
	else:
		NodeManager.get_file_dialog().filters = PoolStringArray(["*.pex;Pixel Express", "*.png;PNG Image", "*.jpg,*.jpeg;JPEG Image", "*.bmp;BMP Image", "*.hdr;Radiance HDR Image", "*.svg;SVG Image", "*.tga;TGA Image", "*.webp;WebP Image"])
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
			var _result = StaticData.open_project(file_path)
		else:
			var _result = NodeManager.get_import_image_popup().connect("hide", self, "_on_ImportImage_hide")
			NodeManager.get_import_image_popup().image_file_path = file_path
			NodeManager.get_import_image_popup().popup_centered()
			



func _on_ImportImage_hide():
	var import_image_popup = NodeManager.get_import_image_popup()
	import_image_popup.disconnect("hide", self, "_on_ImportImage_hide")
	var rows = import_image_popup.preview.rows
	var cols = import_image_popup.preview.cols
	var new_image_width = import_image_popup.preview.new_image_width
	var new_image_height = import_image_popup.preview.new_image_height
	# 이미지 크기 조절
	if NodeManager.get_import_image_popup().result_ok:
		StaticData.open_image(self, NodeManager.get_import_image_popup().image_file_path, rows, cols, new_image_width, new_image_height)
		NodeManager.get_camera().zoom_fit()


func _on_OpenButton_gui_input(event):
	run_gui_input(event)
