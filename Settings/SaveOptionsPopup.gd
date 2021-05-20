extends Control
class_name SaveOptionsPopup


onready var pex_button = $DraggableWindow/VBoxContainer/VBoxContainer/FormatOptions/PexButton
onready var png_button = $DraggableWindow/VBoxContainer/VBoxContainer/FormatOptions/PngButton
onready var gif_button = $DraggableWindow/VBoxContainer/VBoxContainer/FormatOptions/GifButton
onready var preview = $DraggableWindow/VBoxContainer/Background/Preview
onready var sprite_sheet_button = $DraggableWindow/VBoxContainer/VBoxContainer/MethodOptions/SpriteSheetButton
onready var separate_files_button = $DraggableWindow/VBoxContainer/VBoxContainer/MethodOptions/SeparateFilesButton
onready var x1_checkbox = $DraggableWindow/VBoxContainer/VBoxContainer/SizeOptions/x1CheckBox
onready var x2_checkbox = $DraggableWindow/VBoxContainer/VBoxContainer/SizeOptions/x2CheckBox
onready var x3_checkbox = $DraggableWindow/VBoxContainer/VBoxContainer/SizeOptions/x3CheckBox
onready var x4_checkbox = $DraggableWindow/VBoxContainer/VBoxContainer/SizeOptions/x4CheckBox
onready var x8_checkbox = $DraggableWindow/VBoxContainer/VBoxContainer/SizeOptions/x8CheckBox
onready var x16_checkbox = $DraggableWindow/VBoxContainer/VBoxContainer/SizeOptions/x16CheckBox
onready var size_label = $DraggableWindow/VBoxContainer/VBoxContainer/SizeOptions/SizeLabel
onready var file_nums_label = $DraggableWindow/VBoxContainer/VBoxContainer/SizeOptions/FileNumsLabel

enum Format{pex, png, gif}
enum Result{ok, cancel}
var format = Format.pex
var result = Result.cancel
var sprite_sheets_method = true
var origin_size:Vector2

func popup_centered():
	show()
	$DraggableWindow.popup_centered()
	update_format_buttons()
	update_method_buttons()
	update_preview()
	update_all_checkboxes()
	update_file_infomation_labels()
		

func update_format_buttons():
	pex_button.pressed = format == Format.pex
	png_button.pressed = format == Format.png
	gif_button.pressed = format == Format.gif
	
# method buttons을 update한다.
func update_method_buttons():
	sprite_sheet_button.disabled = format != Format.png
	sprite_sheet_button.pressed = sprite_sheets_method
	
	separate_files_button.disabled = sprite_sheet_button.disabled
	separate_files_button.pressed = !sprite_sheets_method
	
			
			
func update_preview():
	var image:Image
	# pex인 경우에는 작으면 1:1로 그리고 이미지가 크면 expand로 그린다.
	if format == Format.pex:
		image = NodeManager.get_current_frame().get_layers().create_layers_image()
	elif format == Format.png:
		image = NodeManager.get_frames().create_sprite_sheet_image()
	Util.update_preview_image(preview, image)		
	preview.update()
	
	origin_size = Vector2(image.get_width(), image.get_height())
	update_file_infomation_labels()
	

func _on_OkButton_pressed():
	result = Result.ok
	hide()

func _on_CancelButton_pressed():
	result = Result.cancel
	hide()




func _on_PexButton_pressed():
	format = Format.pex
	update_format_buttons()
	update_method_buttons()
	update_preview()
	press_size_checkbox(x1_checkbox)
	update_all_checkboxes()
	


func _on_GifButton_pressed():
	format = Format.gif
	update_format_buttons()
	update_method_buttons()
	update_preview()
	update_all_checkboxes()


func _on_PngButton_pressed():
	format = Format.png
	update_format_buttons()
	update_method_buttons()
	update_preview()
	update_all_checkboxes()


func _on_SpriteSheetButton_pressed():
	sprite_sheets_method = true
	update_method_buttons()
	update_preview()


func _on_SeparateFilesButton_pressed():
	sprite_sheets_method = false
	update_method_buttons()
	update_preview()

func update_all_checkboxes():
	if pex_button.pressed:
		disable_all_checkboxes()
	else:
		enable_all_checkboxes()
		
func enable_all_checkboxes():
	var checkboxes = get_all_size_checkboxes()
	for checkbox in checkboxes:
		checkbox.disabled = false
		
func disable_all_checkboxes():
	var checkboxes = get_all_size_checkboxes()
	for checkbox in checkboxes:
		checkbox.disabled = true
		
func uncheck_all_checkboxes():
	var checkboxes = get_all_size_checkboxes()
	for checkbox in checkboxes:
		checkbox.pressed = false
	
func get_image_scale()->int:
	if x1_checkbox.pressed:
		return 1
	elif x2_checkbox.pressed:
		return 2
	elif x3_checkbox.pressed:
		return 3
	elif x4_checkbox.pressed:
		return 4
	elif x8_checkbox.pressed:
		return 8
	elif x16_checkbox.pressed:
		return 16
	return 1
	
	
func get_file_nums()->int:
	var file_nums = 1
	if png_button.pressed && !sprite_sheet_button.pressed:
		file_nums = NodeManager.get_frames().get_frame_count()
	return file_nums
	
func update_file_infomation_labels():
	if origin_size == null:
		return
	var file_nums = get_file_nums()
	file_nums_label.text = "%s : %d" % ["Number of files", file_nums]

	var scale = get_image_scale()
	size_label.text = "%s : %d x %d" % ["Size", origin_size.x * scale / file_nums, origin_size.y * scale]
	
	
func get_all_size_checkboxes()->Array:
	var checkboxes = []
	checkboxes.append(x1_checkbox)
	checkboxes.append(x2_checkbox)
	checkboxes.append(x3_checkbox)
	checkboxes.append(x4_checkbox)
	checkboxes.append(x8_checkbox)
	checkboxes.append(x16_checkbox)
	return checkboxes
	
func press_size_checkbox(checkbox):
	uncheck_all_checkboxes()
	checkbox.pressed = true
	update_file_infomation_labels()
	
func _on_x1CheckBox_pressed():
	press_size_checkbox(x1_checkbox)


func _on_x2CheckBox_pressed():
	press_size_checkbox(x2_checkbox)


func _on_x3CheckBox_pressed():
	press_size_checkbox(x3_checkbox)


func _on_x4CheckBox_pressed():
	press_size_checkbox(x4_checkbox)


func _on_x8CheckBox_pressed():
	press_size_checkbox(x8_checkbox)

func _on_x16CheckBox_pressed():
	press_size_checkbox(x16_checkbox)

