extends Button
class_name AddImageButton

func run():
	_on_AddImageButton_pressed()
	

func on_hide_file_dialog():
	NodeManager.get_file_dialog().disconnect("hide", self, "on_hide_file_dialog")
	if !NodeManager.get_file_dialog().result_ok:
		return
	
	var file_path = NodeManager.get_file_dialog().get_last_selected_file_path()
	if file_path == null || file_path == "":
		return
		
	# 파일을 image로 로딩
	var image:Image = Util.load_image_file(self, file_path)
	if image == null:
		return
	
	Util.AttachImageWithEditTool(image, Vector2(0, 0))
	

func _on_ImportImage_hide():
	NodeManager.get_import_image_popup().disconnect("hide", self, "_on_ImportImage_hide")
	var rows = NodeManager.get_import_image_popup().preview.rows
	var cols = NodeManager.get_import_image_popup().preview.cols
	
	if NodeManager.get_import_image_popup().result_ok:
		StaticData.open_image(self, NodeManager.get_import_image_popup().image_file_path, rows, cols)
		NodeManager.get_camera().zoom_fit()


func _on_AddImageButton_pressed():
	var _tmp = NodeManager.get_file_dialog().connect("hide", self, "on_hide_file_dialog")
	NodeManager.get_file_dialog().save_file_dialog = false
	NodeManager.get_file_dialog().filters = PoolStringArray(["*.png;PNG Image", "*.jpg,*.jpeg;JPEG Image", "*.bmp;BMP Image", "*.hdr;Radiance HDR Image", "*.svg;SVG Image", "*.tga;TGA Image", "*.webp;WebP Image"])
	NodeManager.get_file_dialog().popup_centered()


