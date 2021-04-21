extends Control

var palette_resource = preload("res://Tools/Palette.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func popup_centered():
	$DraggablePopup.popup_centered()

func hide():
	$DraggablePopup.hide()
	
# 새 팔레트를 추가하고 현재 팔레트로 지정하고 setting popup을 닫는다.
func add_new_palette()->Palette:
	var new_palette = palette_resource.instance()
	new_palette.default_colors = false
	NodeManager.get_palettes().add_child(new_palette)
	
	StaticData.current_palette_index = NodeManager.get_palettes().get_palette_count()-1
	
	hide()
	return new_palette
	
func update_color_panel():
	NodeManager.get_color_panel().load_current_palette()
	
func _on_NewPaletteButton_pressed():
	var _new_palette = add_new_palette()
	update_color_panel()

# image로 palette 만들기
func _on_PaletteFromImageButton_pressed():
	var _tmp = NodeManager.get_file_dialog().connect("hide", self, "on_PaletteFromImageButton_FileDialog_hide")
	NodeManager.get_file_dialog().save_file_dialog = false
	NodeManager.get_file_dialog().filters = PoolStringArray(["*.png;PNG Image", "*.jpg,*.jpeg;JPEG Image", "*.bmp ; BMP Image", "*.hdr;Radiance HDR Image", "*.svg ; SVG Image", "*.tga ; TGA Image", "*.webp ; WebP Image"])
	NodeManager.get_file_dialog().popup_centered()
	
func on_PaletteFromImageButton_FileDialog_hide():
	NodeManager.get_file_dialog().disconnect("hide", self, "on_PaletteFromImageButton_FileDialog_hide")
	if NodeManager.get_file_dialog().result_ok:
		var file_path = NodeManager.get_file_dialog().get_last_selected_file_path()
		if file_path == null || file_path == "":
			return
		# 이미지 열기
		var image:Image = Util.load_image_file(self, file_path)
		if image == null:
			return
			
			
		var new_palette = add_new_palette()
		
		# 이미지에서 palette불러옴
		new_palette.set_palette_from_image(image)
		
		update_color_panel()


func _on_PaletteFromLibraryButton_pressed():
	hide()
	$PaletteLibraryPopup.popup_centered()
