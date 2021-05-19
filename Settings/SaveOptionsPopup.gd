extends Control
class_name SaveOptionsPopup


onready var pex_button = $DraggableWindow/VBoxContainer/VBoxContainer/FormatOptions/PexButton
onready var png_button = $DraggableWindow/VBoxContainer/VBoxContainer/FormatOptions/PngButton
onready var gif_button = $DraggableWindow/VBoxContainer/VBoxContainer/FormatOptions/GifButton
onready var preview = $DraggableWindow/VBoxContainer/Background/Preview
onready var sprite_sheet_button = $DraggableWindow/VBoxContainer/VBoxContainer/MethodOptions/SpriteSheetButton
onready var separate_files_button = $DraggableWindow/VBoxContainer/VBoxContainer/MethodOptions/SeparateFilesButton
enum Format{pex, png, gif}
enum Result{ok, cancel}
var format = Format.pex
var result = Result.cancel
var sprite_sheets_method = true

func popup_centered():
	show()
	$DraggableWindow.popup_centered()
	update_format_buttons()
	update_method_buttons()
	update_preview()
		

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
	var image
	# pex인 경우에는 작으면 1:1로 그리고 이미지가 크면 expand로 그린다.
	if format == Format.pex:
		image = NodeManager.get_current_frame().get_layers().create_layers_image()
	elif format == Format.png:
		image = NodeManager.get_frames().create_sprite_sheet_image()
	
	Util.update_preview_image(preview, image)		
	preview.update()

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


func _on_GifButton_pressed():
	format = Format.gif
	update_format_buttons()
	update_method_buttons()
	update_preview()


func _on_PngButton_pressed():
	format = Format.png
	update_format_buttons()
	update_method_buttons()
	update_preview()


func _on_SpriteSheetButton_pressed():
	sprite_sheets_method = true
	update_method_buttons()
	update_preview()


func _on_SeparateFilesButton_pressed():
	sprite_sheets_method = false
	update_method_buttons()
	update_preview()
