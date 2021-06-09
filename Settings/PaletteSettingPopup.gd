extends Control
class_name PaletteSettingPopup

var message_box:MessageBox
var palette_resource = preload("res://Tools/Palette.tscn")
onready var close_palette_button = $DraggablePopup/GridContainer/ClosePaletteButton
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func popup_centered():
	$DraggablePopup.popup_centered()
	
func _process(_delta):
	var palette_count = NodeManager.get_palettes().get_palette_count()
	close_palette_button.disabled = palette_count == 1

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
			
		add_new_palette_from_image(image)

func add_new_palette_from_image(image):
	var new_palette = add_new_palette()
	# 이미지에서 palette불러옴
	new_palette.set_palette_from_image(image)
	
	update_color_panel()
		
func _on_PaletteFromLibraryButton_pressed():
	hide()
	$PaletteLibraryPopup.popup_centered()

# project로 부터 palette를 추출한다.
func _on_PaletteFromProjectButton_pressed():
	var image = NodeManager.get_current_layers().create_layers_image()
	add_new_palette_from_image(image)

# 현재 palette를 이미지로 저장한다.
func _on_SavePaletteButton_pressed():
	var _tmp = NodeManager.get_file_dialog().connect("hide", self, "on_SavePalette_FileDialog_hide")
	NodeManager.get_file_dialog().save_file_dialog = true
	NodeManager.get_file_dialog().default_extension = "pep"
	NodeManager.get_file_dialog().filters = PoolStringArray(["*.pep;Palette"])
	NodeManager.get_file_dialog().popup_centered()

func on_SavePalette_FileDialog_hide():
	NodeManager.get_file_dialog().disconnect("hide", self, "on_SavePalette_FileDialog_hide")
	if NodeManager.get_file_dialog().result_ok:
		var file_path = NodeManager.get_file_dialog().get_last_selected_file_path()
		if file_path == null || file_path == "":
			return
		var palette = NodeManager.get_current_palette()
		var save_dic = palette.get_save_dic()
		var save_file = File.new()
		save_file.open(file_path, File.WRITE)
		save_file.store_line(to_json(save_dic))
		save_file.close()

func _on_LoadPaletteButton_pressed():
	var _tmp = NodeManager.get_file_dialog().connect("hide", self, "on_LoadPalette_FileDialog_hide")
	NodeManager.get_file_dialog().save_file_dialog = false
	NodeManager.get_file_dialog().default_extension = "pep"
	NodeManager.get_file_dialog().filters = PoolStringArray(["*.pep;Palette"])
	NodeManager.get_file_dialog().popup_centered()

func on_LoadPalette_FileDialog_hide():
	NodeManager.get_file_dialog().disconnect("hide", self, "on_LoadPalette_FileDialog_hide")
	if NodeManager.get_file_dialog().result_ok:
		var file_path = NodeManager.get_file_dialog().get_last_selected_file_path()
		if file_path == null || file_path == "":
			return
		
		var palette = add_new_palette()
		var open_file = File.new()
		open_file.open(file_path, File.READ)
		if open_file.get_position() < open_file.get_len():
			var dic = parse_json(open_file.get_line())
			palette.set_save_dic(dic)
		open_file.close()
		update_color_panel()

# 현재 palette를 닫는다.
func _on_ClosePaletteButton_pressed():
	if NodeManager.get_palettes().get_palette_count() <= 1:
		return
		
	hide()
	message_box = Util.show_yesno_message_box(tr("Do you really delete the current palette?") + "\n" + tr("This operation cannot be undone."))
	var _result = message_box.connect("hide", self, "on_MessageBox_hide")
	
func on_MessageBox_hide():
	message_box.disconnect("hide", self, "on_MessageBox_hide")
	popup_centered()
	
	if message_box.result != MessageBox.Result.yes:
		return
		
	var palette = NodeManager.get_current_palette()
	NodeManager.get_palettes().remove_child(palette)
	if StaticData.current_palette_index >= NodeManager.get_palettes().get_palette_count():
		StaticData.current_palette_index = NodeManager.get_palettes().get_palette_count() - 1
		update_color_panel()
	hide()


func _on_PaletteSizeButton_pressed():
	hide()
	$PaletteSizePopup.popup_centered()
	
